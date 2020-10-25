require 'test/unit/assertions'
World(Test::Unit::Assertions)

GT_URL = "https://readysetagile.github.io/presentations/lib/src/xray/CarGasData.html"

def get_element(name)
  case name
  when "Gallons"
    return $driver.find_element(:id, "txtGallons")
  when "Price Per Gallon"
    return $driver.find_element(:id, "txtPrice")
  when "Mileage"
    return $driver.find_element(:id, "txtMileage")
  when "Comments"
    return $driver.find_element(:id, "txtComments")
  when "Calculate"
    return $driver.find_element(:name, "btnCalcTotal")  
  when "Total"
    return $driver.find_element(:id, "txtTotal")
  else
    raise "Element not found: #{name}"
  end
end

def enter_value(x, fieldName)
  element=get_element(fieldName)
  element.clear
  element.send_keys x 
end

Given(/^I navigate to the GasTrak Entry page$/) do
  $driver.get GT_URL
end

Then(/^I will see the GasTrak entry page$/) do
  assert_equal( GT_URL, $driver.current_url, "The current page is not the GasTrak entry page" )
end

Given(/^I enter (\d+) in the (.+) field$/) do |arg1, fieldName|
  enter_value(arg1, fieldName)
end

Given(/^I enter (\d+)\.(\d+) in the (.+) field$/) do |arg1, arg2, fieldName|
  x = "#{arg1}.#{arg2}"
  enter_value(x, fieldName)
end

Given(/^I enter the phrase "([^"]*)" in the (.+) field$/) do |arg1, fieldName|
  element=get_element(fieldName)
  element.clear
  element.send_keys arg1 
end

When(/^I click the (.+) button$/) do |fieldName|
  get_element(fieldName).click
  $driver.save_screenshot('./features/step_definitions/image.png')
end

When(/^I lose focus from the (.+) Field$/) do |fieldName|
  # tab to the next element
  get_element(fieldName).send_keys :tab
  #$driver.save_screenshot('./features/step_definitions/image.png')
end

Then(/^I will see (\d+)\.(\d+) in the (.+) field$/) do |arg1, arg2, fieldName|
  x = "#{arg1}.#{arg2}"
  
  elementVal=get_element(fieldName).attribute('value')
  msg="#{fieldName} is not formatted correctly"
  assert_equal x, elementVal, msg
end

Then(/^I will see (\d+) in the (.+) field$/) do |arg1, fieldName|
  elementVal=get_element(fieldName).attribute('value')
  msg="#{fieldName} is not formatted correctly"
  assert_equal arg1, elementVal, msg
end

Then(/^I will see the phrase "([^"]*)" in the (.+) field$/) do |arg1, fieldName|
  elementVal=get_element(fieldName).attribute('value')
  msg="#{fieldName} is not formatted correctly"
  assert_equal arg1, elementVal, msg
end

