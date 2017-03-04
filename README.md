# README

<h3>Admin Email - admin@gmail.com</h3>
<h3>Admin Password - admin123</h3>
<a href="https://new-test-app-123.herokuapp.com">Link to the app on Heroku</a>

<h3>Functionality</h3>

Users<br>
<ul>
<li>Edit user profile: click Account -> Settings on the page header</li>
<li>View user profile: click Account -> Profile on the page header</li>
<li>Logout: click Account -> Log out on the page header</li>

<li>Create a new bank account: click Create New Account on the homepage</li>
<li>Add users as friends: click Search for other users, then type query(email/name of the user to be added), Click Add Friend</li>
<li>View account details, click Account details</li>
<li>View friends, click Show friends</li>
<li>Transfer money to a friend:</li>
<li>Preconditions: Both sender and receiver should have accounts that are approved by the admin</li>
<li>Click Show Friends -> Transfer Money. The first pull down is source account number, second is destination account number. Click Transfer</li>
<li>Click Show transactions to view transactions</li>
<li>There are buttons to deposit and withdraw to/from accounts that are approved by the admin</li>
</ul>

Admins
<ul>
<li>Viewing profile details and editing them, logging out are done the same way as is the case with the user

<li>Click on manage admins for any of the following actions: Create new admins, View the list of all admins, delete admins
<li>Click on manage accounts for any of the following actions:
<ol>
<li>Approving a bank account for the user
<li>View all the bank accounts
  <ol>
    <li>View transaction history of any account
    <li>Delete an account from the list of accounts
    <li>Close/Re-open an account
  </ol>
<li>Approve/Decline a transaction (Click view transaction requests -> Approve/Decline)
</ol>

<li>Click on manage users for viewing/deleting users, or viewing transaction history of a user
</ul>


<h3>Email Functionality added for transactions!!</h3>
<h3>Borrow Functionality added</h3>
<h4>Edge cases:<h4>
<ol>
<li>If an admin deletes a user, all the user's transactions will be deleted regardless of status
<li>If a user cancels a transaction request, the transaction is deleted from the system
<li>Logout from the user's account, before you delete that user
<li>The user must have a valid email ID to test out the mailer functionality
</ol>
