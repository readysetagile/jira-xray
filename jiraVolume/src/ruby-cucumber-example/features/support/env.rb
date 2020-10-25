require 'rubygems'
require 'selenium-webdriver'
require 'cucumber'

caps = Selenium::WebDriver::Remote::Capabilities.chrome(
    "goog:chromeOptions" => {args: %w[headless disable-gpu window-size=1920,1080 no-sandbox disable-dev-shm-usage]})
$driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps

