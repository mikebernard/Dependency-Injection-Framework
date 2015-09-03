@isTest
private class TestAccountTypeBean{

	@isTest
	private static void testAccountTypeIsUpdated(){
		Account testAccount = new Account(
			Name = 'Test Account',
			Type = 'Some Type');

		insert testAccount;
		AccountTypeBean bean = new AccountTypeBean();

		Test.startTest();

		bean.inflate(testAccount);
		bean.execute();

		Test.stopTest();

		Account accountFromDB = [
			SELECT
				Id,
				Type
			FROM
				Account
			WHERE
				Name =: testAccount.Name
			LIMIT 1
		];

		System.assertEquals('Dreamforce is awesome!', accountFromDB.Type);
	}
}