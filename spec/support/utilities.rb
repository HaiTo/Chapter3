include ApplicationHelper

# Specファイル中で呼び出された場合に行われる
# example -- before { valied_signin(user)}
def valid_signin user
  fill_in "Email",  with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert,alert-error',text:message)
  end
end
