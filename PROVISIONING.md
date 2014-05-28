== Server Setup

1. Clone repository
2. Config database.yml
3. Run migrations
4. Start Server

* Notes: Because PrettyClose-Facebooker assume the user provide the authentication token, this server behave as such. Before querying, please visit https://developers.facebook.com/tools/ and check "Graph Explorer" to get an authentication token.

== Querying

1. Get Facebook friends

  facebook-friends/:facebook_user_id/:auth_token

2. Search Facebook pages

  facebook-pages/:search_term/:auth_token

3. Get Checkins of Facebook Page
  
  facebook-checkins/:facebook_page_id/:auth_token

4. Get User Checkins

  facebook-checkin-pages/:facebook_user_id/:auth_token

5. Get Users List that LIKED a Facebook Page

  facebook-page-likes/:facebook_page_id/:facebook_user_list/:auth_token

6. Get Images and Albums from Facebook Page

  facebook-page-albums/:facebook_page_id/:auth_token

7. Subscribe to a Facebook Page and receive updates from that page.

  