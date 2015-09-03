global virtual class BeanRegistry {
	private Map<String, BeanDefinition> beanDefinitionUniqueNameMap
		= new Map<String, BeanDefinition>();
	private Map<String, Map<String, BeanDefinition>> beanDefinitionContractMap
		= new Map<String, Map<String, BeanDefinition>>();

	protected BeanRegistry(){
		// protected constructor
	}

	global void registerBean(
		String uniqueName,
		String contractName,
		String className){

		if(isRegistered(uniqueName)){
			Bean_Registry__c r = getBeanByUniqueName(uniqueName);
			if(r != null){
				r.Contract_Name__c = contractName;
				r.Class_Name__c = className;
				r.Is_Active__c = true;
				Database.update(r);
			}
		} else {
			Bean_Registry__c r = new Bean_Registry__c(
				Name = '' + (Math.random() * 99) + '', //this can be anything
				Unique_Name__c = uniqueName,
				Contract_Name__c = contractName,
				Class_Name__c = className,
				Is_Active__c = true);
			Database.insert(r);
		}

		// update the cache
		updateBeanDefinitionCache(new BeanDefinition(uniqueName, Type.forName(contractName), Type.forName(className), true));
	}

	global void deregisterBean(BeanDefinition bd){
		if(isRegistered(bd.getUniqueName())){
			Bean_Registry__c r = getBeanByUniqueName(bd.getUniqueName());
			r.Is_Active__c = false;
			Database.update(r);

			removeBeanDefinitionFromCache(bd);
		}
	}


	public List<BeanDefinition> getBeanDefinitionByContract(String contract){
		Map<String, BeanDefinition> bdMap = beanDefinitionContractMap.get(contract);

		if(bdMap == null || bdMap.size() == 0){
			bdMap = new Map<String, BeanDefinition>();

			String query = 'SELECT '+
				Bean_Registry__c.Name.getDescribe().getName() +',' +
				Bean_Registry__c.Unique_Name__c.getDescribe().getName() +',' +
				Bean_Registry__c.Contract_Name__c.getDescribe().getName() +',' +
				Bean_Registry__c.Class_Name__c.getDescribe().getName() +',' +
				Bean_Registry__c.Is_Active__c.getDescribe().getName() +'' +
				' FROM ' +
				Bean_Registry__c.sObjectType.getDescribe().getName()  +
				' WHERE ' +
				 Bean_Registry__c.Contract_Name__c.getDescribe().getName() +' != NULL ' +
				' AND ' +
				 Bean_Registry__c.Contract_Name__c.getDescribe().getName() +' =: contract ' +
				' ORDER BY ' +
				Bean_Registry__c.Unique_Name__c.getDescribe().getName();

			List<Bean_Registry__c> registry = Database.query(query);

			for(Bean_Registry__c r: registry){
				bdMap.put(r.Unique_Name__c, createBeanDefinition(r));
			}
			beanDefinitionContractMap.put(contract, bdMap);
		}
		return bdMap.values();

	}

	public BeanDefinition getBeanDefinitionByUniqueName(String uniqueName){
		BeanDefinition bd = beanDefinitionUniqueNameMap.get(uniqueName);

		if(bd == null){
			Bean_Registry__c r = getBeanByUniqueName(uniqueName);
			if(r != null){
				bd = createBeanDefinition(r);
			}
		}
		return bd;
	}

	global Boolean isRegistered(String uniqueName){
		return getBeanByUniqueName(uniqueName) != null;
	}

	global virtual String generateUniqueBeanName(Type superType, String beanFunction){
		return superType.getName() + ':' + beanFunction;
	}

	private void updateBeanDefinitionCache(BeanDefinition bd){
		if(bd.getContractType() != null){
			Map<String, BeanDefinition> bdMap
				= beanDefinitionContractMap.get(bd.getContractType().getName());

			if(bdMap == null){
				bdMap = new Map<String, BeanDefinition>();
			}
			bdMap.put(bd.getUniqueName(), bd);
		}
		beanDefinitionUniqueNameMap.put(bd.getUniqueName(), bd);
	}

	private void removeBeanDefinitionFromCache(BeanDefinition bd){
		BeanDefinition removedBeanDefinition
			= beanDefinitionUniqueNameMap.remove(bd.getUniqueName());

		if(removedBeanDefinition != null && removedBeanDefinition.getContractType() != null){
			Map<String, BeanDefinition> bdMap = beanDefinitionContractMap.get(
				removedBeanDefinition.getContractType().getName());

			if(bdMap != null){
				bdMap.remove(removedBeanDefinition.getUniqueName());
			}
		}
	}

	private Bean_Registry__c getBeanByUniqueName(String uniqueName){
		for(Bean_Registry__c r : Bean_Registry__c.getAll().values()){
			if(r.Unique_Name__c == uniqueName){
				return r;
			} else {
				createBeanDefinition(r);
			}
		}
		return null;
	}

	private BeanDefinition createBeanDefinition(Bean_Registry__c r){
		BeanDefinition bd = new BeanDefinition(
			r.Unique_Name__c,
			Type.forName(r.Contract_Name__c),
			Type.forName(r.Class_Name__c),
			r.Is_Active__c
		);
		beanDefinitionUniqueNameMap.put(bd.getUniqueName(), bd);
		return bd;
	}

	global static BeanRegistry getInstance(){
		return instance;
	}
	private static BeanRegistry instance = new BeanRegistry();
}