global without sharing class BeanFactory {

	private BeanFactory(){
		// private constructor
	}

	global Object getBeanByDefinition(BeanDefinition bd){
		Object bean;

		if(bd != null && bd.getClassType() != null){
			bean = bd.getClassType().newInstance();
		}
		return bean;
	}

	global Object getBeanByUniqueName(String uniqueName){
		return getBeanByDefinition(
			BeanRegistry.getInstance().getBeanDefinitionByUniqueName(
				uniqueName));
	}

	global List<Object> getBeansByContract(String contract){
		List<Object> beans = new List<Object>();

		for(BeanDefinition bd :
			BeanRegistry.getInstance().getBeanDefinitionByContract(contract)){

			Object bean = getBeanByDefinition(bd);
			if(bean != null){
				beans.add(bean);
			}
		}
		return beans;
	}

	global static BeanFactory getInstance(){
		return instance;
	}

	private static BeanFactory instance = new BeanFactory();
}