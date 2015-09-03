@isTest
public class TestUpdateAccountTypeController{

	@isTest
	private static void testControllerExecutesSomeBean(){
		BeanRegistry.getInstance().registerBean(
			UpdateAccountTypeController.beanUniqueName,
			'IBean',
			'TestUpdateAccountTypeController.TestBean'
		);

		Account testAccount = new Account(
			Name = 'Test Account',
			Type = 'Some Type');
		insert testAccount;

		ApexPages.StandardController ctrl = new ApexPages.StandardController(testAccount);
		UpdateAccountTypeController acctCtrl = new UpdateAccountTypeController(ctrl);
		acctCtrl.changeType();

		Account accountFromDB = [
			SELECT
				Id,
				Name
			FROM
				Account
			LIMIT 1
		];

		System.assertEquals('Testing...', accountFromDB.Name);
	}

	public class TestBean implements IBean{
		private Account acct;

		public void inflate(sObject obj){
			acct = (Account)obj;
		}

		public void execute(){
			this.acct.Name = 'Testing...';
			update this.acct;
		}
	}
}