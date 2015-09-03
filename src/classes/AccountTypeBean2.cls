public class AccountTypeBean2 implements IBean{
	private Account acct;

	public void inflate(sObject acct){
		this.acct = (Account)acct;
	}

	public void execute(){
		this.acct.Type = 'I am ready to go home!';
		update acct;
	}
}