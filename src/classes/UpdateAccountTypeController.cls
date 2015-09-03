public with sharing class UpdateAccountTypeController {

	private sObject acct;

	public UpdateAccountTypeController(ApexPages.StandardController stdController) {
		this.acct = (sObject)stdController.getRecord();
	}

	public PageReference changeType(){
		IBean bean = (IBean)BeanFactory.getInstance().getBeanByUniqueName(beanUniqueName);
		bean.inflate(this.acct);
		bean.execute();

		return new PageReference('/' + this.acct.Id);
	}

	@testVisible
	private static final String beanUniqueName = 'account-type-updater';
}