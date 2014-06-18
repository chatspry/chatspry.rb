# Chatspry

API wrapper for Chatspry to be used from any ruby **1.9**, **2.0**
or **2.1** application. Dependent on the following libraries:

- [Faraday](https://github.com/lostisland/faraday)
- [Hashie](https://github.com/intridea/hashie).

## Installation

Add this line to your project Gemfile:

```ruby
gem "chatspry", "~> 0.0.1.pre3"
```

Then execute this in a command line from your project directory:

```bash
$ bundle
```

Or install it on it's own with RubyGems:

```bash
$ gem install chatspry
```

## Usage

### Basic usage

```ruby
require "chatspry"

client = Chatspry::Client.new
client.access_token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

user = client.get("/v1/user")
# => { "user" => { "id"=>"...", "handle"=>"zeeraw", "name"=>"Philip Vieira", "updated_at"=>1403036249, "created_at"=>1403036249 } }

user.handle
# => "zeeraw"
```

## Contributing

#### 1. Fork it at https://github.com/chatspry/chatspry.rb/fork

#### 2. Create your feature branch nested under `feature/`

```bash
$ git checkout -b feature/my-important-change
```

#### 3. Commit your changes

```bash
$ git commit -am 'The gem now behaves this way, because reasons'
```

#### 4. Push to the branch

```bash
$ git push origin feature/my-important-change
```

#### 5. Create a new Pull Request
