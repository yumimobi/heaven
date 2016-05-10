# Heaven [![Build Status](https://travis-ci.org/atmos/heaven.png?branch=master)](https://travis-ci.org/atmos/heaven)

Heaven is an API that integrates with GitHub's [Deployment API][1]. It receives [deployment events][5] from GitHub and pushes code to your servers.

Heaven currently supports [Capistrano][15], [Fabric][10], and [Heroku][22] deployments. It also has a notification system for broadcasting  [deployment status events][6] to chat services(e.g. [Campfire][7], [Hipchat][8], [SlackHQ][9], and [Flowdock][21]).  It can be hosted on Heroku for a few dollars a month.

# Overview

Heaven 是用于部署的程序, 这里简称部署服务器.

在 Slack 里面输入
	
	zbot deploy adxstat/v0.0.1 to production
	
**zbot** 就会创建一个部署命令, 发送给 github

**部署服务器** 收到 [GitHub webhooks][2] (部署命令)后自动从 github 把代码拉下来

如果项目里面有 **fabfile.py**(用来规划如何部署), **部署服务器** 会执行

	fab -R production deploy:branch_name=v0.0.1

之后把输出提交到 [gist][4]

```
+---------+             +--------+            +----------+         +-------------+
|  Hubot  |             | GitHub |            |  Heaven  |         | Your Server |
+---------+             +--------+            +----------+         +-------------+
     |                      |                       |                     |
     |  Create Deployment   |                       |                     |
     |--------------------->|                       |                     |
     |                      |                       |                     |
     |  Deployment Created  |                       |                     |
     |<---------------------|                       |                     |
     |                      |                       |                     |
     |                      |   Deployment Event    |                     |
     |                      |---------------------->|                     |
     |                      |                       |     SSH+Deploys     |
     |                      |                       |-------------------->|
     |                      |                       |                     |
     |                      |   Deployment Status   |                     |
     |                      |<----------------------|                     |
     |                      |                       |                     |
     |                      |                       |   Deploy Completed  |
     |                      |                       |<--------------------|
     |                      |                       |                     |
     |                      |   Deployment Status   |                     |
     |                      |<----------------------|                     |
     |                      |                       |                     |
```

[1]: http://developer.github.com/v3/repos/deployments/
[2]: https://github.com/blog/1778-webhooks-level-up
[3]: https://github.com/resque/resque
[4]: https://gist.github.com/
[5]: https://developer.github.com/v3/repos/deployments/#create-a-deployment
[6]: https://developer.github.com/v3/repos/deployments/#create-a-deployment-status
[7]: https://campfirenow.com/
[8]: https://www.hipchat.com/
[9]: https://slack.com/
[10]: http://www.fabfile.org/
[11]: http://www.getchef.com/
[12]: http://puppetlabs.com/
[13]: https://devcenter.heroku.com/articles/build-and-release-using-the-api
[14]: https://developer.github.com/v3/repos/contents/#get-archive-link
[15]: http://capistranorb.com/
[16]: https://github.com/settings/applications
[17]: https://devcenter.heroku.com/articles/oauth#direct-authorization
[18]: https://www.phusionpassenger.com/
[19]: https://devcenter.heroku.com/articles/releases
[20]: https://github.com/atmos/hubot-deploy
