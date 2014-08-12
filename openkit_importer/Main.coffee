require "./Globals"

importData = require "./Importer"

importData(
  app_id: 1
  data: {
    "leaderboards": [
        {
            "app_id": 1,
            "created_at": "2014-07-06T15:17:27.000Z",
            "gamecenter_id": "",
            "gpg_id": "",
            "icon_content_type": null,
            "icon_file_name": null,
            "icon_file_size": null,
            "icon_updated_at": null,
            "icon_url": "http://api.gameeso.comhttps://ok-shared.s3-us-west-2.amazonaws.com/leaderboard_icon.png",
            "id": 1,
            "name": "Poopie!",
            "player_count": 1,
            "priority": 100,
            "scores": [
                {
                    "created_at": "2014-07-06T21:18:44.000Z",
                    "display_string": null,
                    "id": 3,
                    "is_users_best": true,
                    "leaderboard_id": 1,
                    "meta_doc_url": null,
                    "metadata": 0,
                    "rank": 1,
                    "user_id": 1,
                    "value": 30
                }
            ],
            "sort_type": "HighValue",
            "updated_at": "2014-07-06T15:17:27.000Z"
        }
    ],
    "users": [
        {
            "created_at": "2014-07-06T21:17:01.000Z",
            "custom_id": null,
            "developer_id": 1,
            "fb_id": "100102273765146",
            "gamecenter_id": null,
            "google_id": null,
            "id": 1,
            "nick": "Peter Willemsen",
            "twitter_id": null,
            "updated_at": "2014-07-06T21:17:01.000Z"
        },
        {
            "created_at": "2014-07-06T21:17:01.000Z",
            "custom_id": null,
            "developer_id": 1,
            "fb_id": "100002273765246",
            "gamecenter_id": null,
            "google_id": null,
            "id": 2,
            "nick": "DJ Willemsen",
            "twitter_id": null,
            "updated_at": "2014-07-06T21:17:01.000Z"
        }
        {
            "created_at": "2014-07-06T21:17:01.000Z",
            "custom_id": null,
            "developer_id": 1,
            "fb_id": "100002273765146",
            "gamecenter_id": null,
            "google_id": null,
            "id": 5,
            "nick": "Sak Willemsen",
            "twitter_id": null,
            "updated_at": "2014-07-06T21:17:01.000Z"
        }
    ]
  }
)
