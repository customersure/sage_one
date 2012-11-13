# Sage One
Faraday-based Ruby wrapper for the Sage One API

## Installation
Add `sage_one` gem to your `Gemfile`

    gem 'sage_one'

## Documentation
[http://rdoc.info/gems/sage_one][documentation]

[documentation]: http://rdoc.info/gems/sage_one

## Usage
### Authentication
This documentation assumes you have already obtained a client id and client secret from Sage.

To make any requests to the Sage One API, you must present an OAuth access token. The basic flow for obtaining a token for a user is as follows:

```ruby
# The code below is over-simplified. Read Sage's own API docs and the documentation for SageOne::Oauth to get
# a better idea of how to implement this in the context of your own app.
SageOne.configure do |c|
  c.client_id     = "YOUR_CLIENT_ID_OBTAINED_FROM_SAGE"
  c.client_secret = "YOUR_CLIENT_SECRET_OBTAINED_FROM_SAGE"
end

# Redirect the current user to SageOne. This will give them the choice to link SageOne with your app.
# and subsequently redirect them back to your callback_url with an authorisation_code if they choose to do so.
redirect_to SageOne.authorize_url('https://www.example.com/your_callback_url')

# Then, in the callback URL controller, run get_access_token, i.e.
response = SageOne.get_access_token(params[:code], 'https://www.example.com/your_callback_url')
User.save_access_token(response.access_token) unless response.access_token.nil?
```

### Standard API requests
Once you have an access token, configure the client with it, along with your client id and secret, and you're good to go:

```ruby
SageOne.configure do |c|
  c.client_id     = "YOUR_CLIENT_ID_OBTAINED_FROM_SAGE"
  c.client_secret = "YOUR_CLIENT_SECRET_OBTAINED_FROM_SAGE"
  c.access_token  = current_user.access_token
end

# Get an array of all sales invoices
invoices = SageOne.sales_invoices

# Add search params
SageOne.sales_invoices(start_date: '28/02/2010')
```
You can configure the `SageOne` client on the fly. For example, if you'd prefer to configure your client_id and secret in an
initializer then set the access_token in a controller:

```ruby
SageOne.new(access_token: current_user.access_token).sales_invoices
```

### Pagination
You can request any 'page' of results returned from the API by adding `start_index: n` to any API call:

```ruby
SageOne.sales_invoices(start_index: 30)
SageOne.sales_invoices(start_date: '28/02/2010', start_index: 50)

```

You can also turn on 'auto traversal' to have the client recursively get a full result set. Beware of using this on large result sets.

```ruby
# Recursively request ALL sales invoices, appending them to the body of the request
SageOne.new(auto_traversal: true).sales_invoices
```

### Other usage notees
- HTTP 1.1 requires that you set a Host: header. Whilst the gem will currently work fine without this, if conformance to the spec is important to you, set this with `request_host=`
- You can set a proxy server with `proxy=`
- To obtain raw, unprocessed responses back from the API, specify `raw_responses = true`. Read the documentation for more information on this.


## Open Source
See the [LICENSE][] file for more information.

We actively encourage contributions to this gem. Whilst we have provided a robust, tested, documented, full-featured core of an wrapper for this new API, we have to balance our time spent on this gem against [the day job][cs].
Therefore, if there are API endpoints we haven't covered yet, please fork us, add tests, documentation and coverage, and submit a pull request.

### Submitting a Pull Request
1. [Fork the repository.][fork]
2. [Create a topic branch.][branch]
3. Add specs for your unimplemented feature or bug fix.
4. Run `bundle exec rake spec`. If your specs pass, return to step 3.
5. Implement your feature or bug fix.
6. Run `bundle exec rake spec`. If your specs fail, return to step 5.
7. Run `open coverage/index.html`. If your changes are not completely covered
   by your tests, return to step 3.
8. Add documentation for your feature or bug fix.
9. Run `bundle exec rake doc:yard`. If your changes are not 100% documented, go
   back to step 8.
10. Add, commit, and push your changes.
11. [Submit a pull request.][pr]

[fork]: http://help.github.com/fork-a-repo/
[branch]: http://learn.github.com/p/branching.html
[pr]: http://help.github.com/send-pull-requests/
[cs]: http://www.customersure.com/

## Supported Ruby Versions
TODO

## Contributors and Inspiration

[SageOne][sageone] is a product of [The Sage Group][sage].

The `sage_one` gem was created by [Luke Brown][luke] and [Chris Stainthorpe][chris] whilst at [CustomerSure][cs], but is heavily inspired by the following gems: [Octokit][], [Twitter][], and [instagram-ruby-gem][].

[sage]: http://www.sage.com/
[sageone]: http://www.sageone.com/
[luke]: http://www.tsdbrown.com/
[chris]: http://www.randomcat.co.uk/
[octokit]: https://github.com/pengwynn/octokit/
[twitter]: https://github.com/sferik/twitter/
[instagram-ruby-gem]: https://github.com/Instagram/instagram-ruby-gem/

## Copyright
Copyright (c) 2011 Chris Stainthorpe, Luke Brown. See [LICENSE][] for details.

[license]: https://github.com/customersure/sage_one/blob/master/LICENSE
