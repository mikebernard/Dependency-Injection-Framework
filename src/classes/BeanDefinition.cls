global without sharing class BeanDefinition {
	private String uniqueName;
	private Type contractType;
	private Type classType;
	private Boolean isActive;

	global BeanDefinition(
		String uniqueName,
		Type contractType,
		Type classType,
		Boolean isActive){

		this.uniqueName = uniqueName;
		this.contractType = contractType;
		this.classType = classType;
		this.isActive = isActive;
	}
	global String getUniqueName(){
		return this.uniqueName;
	}
	global Type getContractType(){
		return this.contractType;
	}
	global Type getClassType(){
		return this.classType;
	}
	global Boolean getIsActive(){
		return this.isActive;
	}
}