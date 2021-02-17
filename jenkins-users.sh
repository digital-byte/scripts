// Run from jenkins Script Console with admin privledges 
import hudson.model.User
import hudson.tasks.Mailer
import jenkins.model.Jenkins

def realm = Jenkins.getInstance().getSecurityRealm()
def users = realm.getAllUsers()
for (User u : users) {
  	def uid = u.getId()
    def mailAddress = u.getProperty(Mailer.UserProperty.class).getAddress()
    print(uid + ", " + mailAddress + "\r")
}
