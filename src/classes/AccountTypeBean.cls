public class AccountTypeBean implements IBean{
	private Account acct;

	public void inflate(sObject acct){
		this.acct = (Account)acct;
	}

	public void execute(){
		this.acct.Type = 'Dreamforce is awesome!';
		update acct;
	}
}