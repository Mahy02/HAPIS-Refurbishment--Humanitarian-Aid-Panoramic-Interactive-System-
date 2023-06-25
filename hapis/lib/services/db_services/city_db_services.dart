class cityDBServices {
//retreieve all info needed for city
/*
number of seekers in this city
number of givers in this city
list of seekers for this city - addresses
list of givers for this city  - addresses
number of in progress donations for this city
number of successful donations for this city
top 3 donated categories in this city

*/
//city name is from userstable
//city coordinates is from users table
  // Retrieve the number of seekers in this city
  int getNumberOfSeekers() {
   
    return 50;
  }

  // Retrieve the number of givers in this city
  int getNumberOfGivers() {
    return 30;
  }

  // Retrieve the list of seekers for this city - addresses
  List<String> getListOfSeekers() {
    return [
      'Address 1',
      'Address 2',
      'Address 3',
    ];
  }

  // Retrieve the list of givers for this city - addresses
  List<String> getListOfGivers() {
    return [
      'Address A',
      'Address B',
      'Address C',
    ];
  }

  // Retrieve the number of in-progress donations for this city
  int getNumberOfInProgressDonations() {
    return 10;
  }

  // Retrieve the number of successful donations for this city
  int getNumberOfSuccessfulDonations() {
    // Hardcoded value for demonstration
    return 20;
  }

  // Retrieve the top 3 donated categories in this city
  List<String> getTopDonatedCategories() {
    return [
      'Category 1',
      'Category 2',
      'Category 3',
    ];
  }
}
