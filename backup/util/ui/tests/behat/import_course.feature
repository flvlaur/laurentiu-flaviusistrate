@core @core_backup
Feature: Import course's contents into another course
  In order to move and copy contents between courses
  As a teacher
  I need to import a course contents into another course selecting what I want to import

  Background:
    Given the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1        | 0        |
      | Course 2 | C2        | 0        |
    And the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher1 | Teacher   | 1        | teacher1@example.com |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
      | teacher1 | C2     | editingteacher |

  Scenario: Import course's contents to another course
    Given I log in as "teacher1"
    And the following "activities" exist:
      | activity | name               | course | idnumber   |
      | data     | Test database name | C1     | database1  |
      | forum    | Test forum name    | C1     | forum1     |
    And the following "blocks" exist:
      | blockname   | contextlevel | reference | pagetypepattern | defaultregion |
      | comments    | Course       | C1        | course-view-*   | side-pre      |
      | blog_recent | Course       | C1        | course-view-*   | side-pre      |
    When I import "Course 1" course into "Course 2" course using this options:
    Then I should see "Test database name"
    And I should see "Test forum name"
    And I should see "Comments" in the "Comments" "block"
    And I should see "Recent blog entries"

  Scenario: Import process with permission option
    Given the following "permission overrides" exist:
      | capability         | permission | role    | contextlevel | reference |
      | enrol/manual:enrol | Allow      | teacher | Course       | C1        |
    And I log in as "teacher1"
    When I import "Course 1" course into "Course 2" course using this options:
      | Initial | Include permission overrides | 1 |
    And I am on the "Course 1" "permissions" page
    Then I should see "Non-editing teacher (1)"
    And I set the field "Advanced role override" to "Non-editing teacher (1)"
    And I click on "//div[@class='advancedoverride']/div/form/noscript/input" "xpath_element"
    And "enrol/manual:enrol" capability has "Allow" permission

  Scenario: Import process without permission option
    Given the following "permission overrides" exist:
      | capability         | permission | role    | contextlevel | reference |
      | enrol/manual:enrol | Allow      | teacher | Course       | C1        |
    And I log in as "teacher1"
    When I import "Course 1" course into "Course 2" course using this options:
      | Initial | Include permission overrides | 0 |
    And I am on the "Course 2" "permissions" page
    Then I should see "Non-editing teacher (0)"
