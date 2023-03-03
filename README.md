# EmployeePortal

A Sample app, to orchastrate the optimized pagination.

Pagination basically boils down to a limit and offset in SQL queries. And, limit and offset is a bit slow as we go deeper into the result set when the dataset has a large amount of data.

We do have couple of ways where we can optimize the performance of the deeper pagination. Both everything has its pros and cons.

* Pagination by using Deferred Joins.
  - This will be slow for small data sets, as this required to execute a sub-query to pluck the ids of the requested page with limit. And then fetches the complete data for those records in that page.
  - Mainly, we should make sure to add the index for the colums which will be used for ordering.
* Cursor Based Pagination.
  - This will be very optimized in all cases, but we have to compromize that, we can not directly fetch the records for `page n`.
  - This will be useful when clients wants to implement infinite scrolling.
  - We always can fetch the data for next/previous pages only.

Implementation:
* Created a model for Employee
* Added a basic token based authentication.
* Added an end-point, to fetch the list of employees
  - `GET /v1/employees`
  - Parameters required for getting the pagination by Deferred Joins:
    * per_page: (optional) refers the limit of records in the current page
    * page: (optional) refers to the records in the page user trying to access
  - parameters required for getting the pagination results by cursor
    * per_page: (optional) refers the limit of records in the current page
    * cursor_key: name of the field the cursor value belongs to. It is totally customizable at the controller level. We can allow only the fields which are having indexing on them.
    * after_cursor: refers to the position of the cursor, to fetch the records of next page. 
    * before_cursor: refers to the position of the cursor, to fetch the records of previous page
   
 * Based on the input parameters, API will select the pagination method and fetches the records.
 * Both Paginations are written in such a way that, we can use this in any controller for any model class.
 * Added requests specs, to test the expectations for both implementations.
 * A sample employee dataset with `1,200,380` records available [here](https://drive.google.com/file/d/1GV2O0iMt7qvVsDWTCfAnWY6ttp7qH7Ox/view?usp=share_link). Which I have populated in my local environment for testing purpose.
