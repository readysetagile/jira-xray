Then(/^I LogIn in Facebook$/) do
  driver = $driver
  driver.get "https://www.facebook.com"

  element=driver.find_element :id => "email"
  element.send_keys "testgenie@gmail.com"
  element1 = driver.find_element :id => "pass"
  element1.send_keys "123"
  element2 = driver.find_element :name => "login"
  element2.click
  sleep 2
end
