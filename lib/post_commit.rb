require "json"
require "net/http"
require "uri"
require "json"

require "post_commit/errors"
require "post_commit/hooks"
require "post_commit/hooks/base"
require "post_commit/hooks/basecamp"
require "post_commit/hooks/campfire"
require "post_commit/hooks/friend_feed"
require "post_commit/hooks/light_house"
require "post_commit/hooks/twitter"
require "post_commit/version"

PostCommit::Hooks.register :basecamp, PostCommit::Hooks::Basecamp
PostCommit::Hooks.register :campfire, PostCommit::Hooks::Campfire
PostCommit::Hooks.register :friendfeed, PostCommit::Hooks::FriendFeed
PostCommit::Hooks.register :lighthouse, PostCommit::Hooks::LightHouse
PostCommit::Hooks.register :twitter, PostCommit::Hooks::Twitter

# Send a notification to the specified service. This method is just
# a shorcut to the PostCommit::Hooks module.
#
#   post_commit :twitter do
#     authorize :username => "johndoe", :password => "test"
#     post "Some message!"
#   end
def post_commit(service, &block)
  hook_class = PostCommit::Hooks.hooks[service.to_sym]

  raise PostCommit::UnknownHookError unless hook_class

  hook = hook_class.new
  hook.instance_eval(&block)
  hook
end
