# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 0) do

  create_table "clubmembers", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string   "clubid",   limit: 32, null: false
    t.string   "userid",   limit: 32, null: false
    t.datetime "joindate",            null: false
    t.string   "admin",    limit: 1
    t.index ["clubid"], name: "clubid", using: :btree
    t.index ["userid"], name: "userid", using: :btree
  end

  create_table "clubs", primary_key: "clubid", id: :string, limit: 32, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string   "name",           limit: 256
    t.text     "keywords",       limit: 16777215
    t.text     "desc",           limit: 16777215
    t.text     "url",            limit: 16777215
    t.text     "contacts",       limit: 16777215
    t.text     "contacts_plain", limit: 16777215
    t.datetime "created",                         null: false
    t.string   "members_public", limit: 1
    t.index ["name", "keywords", "desc"], name: "name", type: :fulltext
  end

  create_table "compdivs", primary_key: "divid", id: :bigint, unsigned: true, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string  "compid",  limit: 32,       null: false
    t.integer "divno",                    null: false
    t.text    "divname", limit: 16777215
    t.text    "divdesc", limit: 16777215
    t.index ["compid"], name: "compid", using: :btree
  end

  create_table "competitions", primary_key: "compid", id: :string, limit: 32, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.text     "title",         limit: 16777215
    t.text     "series",        limit: 16777215
    t.text     "desc",          limit: 16777215
    t.text     "url",           limit: 16777215
    t.text     "organizers",    limit: 16777215
    t.text     "organizersExt", limit: 16777215
    t.text     "judges",        limit: 16777215
    t.text     "judgesExt",     limit: 16777215
    t.date     "qualopen"
    t.date     "qualclose"
    t.date     "awarddate"
    t.datetime "created",                        null: false
    t.string   "editedby",      limit: 32,       null: false
    t.datetime "moddate",                        null: false
    t.bigint   "pagevsn",                        null: false
    t.text     "keywords",      limit: 16777215
    t.index ["title", "series", "keywords", "desc"], name: "title", type: :fulltext
  end

  create_table "compgames", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string  "compid", limit: 32, null: false
    t.bigint  "divid",             null: false
    t.string  "gameid", limit: 32, null: false
    t.string  "place"
    t.integer "seqno"
    t.index ["compid"], name: "compid", using: :btree
    t.index ["gameid"], name: "gameid", using: :btree
  end

  create_table "compprofilelinks", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string   "compid",  limit: 32, null: false
    t.string   "userid",  limit: 32, null: false
    t.datetime "moddate",            null: false
    t.string   "role",    limit: 1
    t.index ["compid"], name: "compid", using: :btree
    t.index ["userid"], name: "userid", using: :btree
  end

  create_table "comps_history", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string   "compid",   limit: 32,    null: false
    t.string   "editedby", limit: 32,    null: false
    t.datetime "moddate",                null: false
    t.bigint   "pagevsn",                null: false
    t.binary   "deltas",   limit: 65535
    t.index ["compid"], name: "compid", using: :btree
  end

  create_table "crossrecs", primary_key: "fromgame", id: :string, limit: 32, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string   "togame",  limit: 32,       null: false
    t.string   "userid",  limit: 32,       null: false
    t.text     "notes",   limit: 16777215
    t.datetime "created",                  null: false
    t.index ["userid"], name: "userid", using: :btree
  end

  create_table "downloadhelp", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.integer "fmtid",                            default: 0, null: false, unsigned: true
    t.integer "osid",                             default: 0, null: false, unsigned: true
    t.integer "osvsnid",                                                   unsigned: true
    t.text    "dlinstructions",  limit: 16777215
    t.text    "runinstructions", limit: 16777215
    t.text    "installer",       limit: 16777215
  end

  create_table "extreviews", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string  "gameid",       limit: 32,       default: "", null: false
    t.bigint  "reviewid",                                                unsigned: true
    t.text    "url",          limit: 65535,                 null: false
    t.string  "sourcename",                    default: "", null: false
    t.text    "sourceurl",    limit: 16777215
    t.integer "displayorder"
    t.index ["gameid"], name: "gameid", using: :btree
    t.index ["reviewid"], name: "reviewid", using: :btree
  end

  create_table "filetypes", unsigned: true, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string "externid",  limit: 32,       default: "", null: false
    t.string "extension", limit: 128
    t.string "fmtname",   limit: 64,       default: "", null: false
    t.text   "desc",      limit: 65535,                 null: false
    t.string "website"
    t.binary "icon",      limit: 16777215
    t.string "fmtclass",  limit: 2
  end

  create_table "gamefwds", primary_key: "gameid", id: :string, limit: 32, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string   "fwdgameid", limit: 32,       null: false
    t.datetime "created",                    null: false
    t.text     "notes",     limit: 16777215
  end

  create_table "gamelinks", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string  "gameid",            limit: 32,       default: "", null: false
    t.string  "title",                              default: "", null: false
    t.text    "desc",              limit: 16777215
    t.text    "url",               limit: 65535,                 null: false
    t.integer "displayorder",      limit: 3,        default: 0,  null: false
    t.integer "fmtid",                              default: 0,  null: false, unsigned: true
    t.integer "osid",                                                         unsigned: true
    t.integer "osvsn",                                                        unsigned: true
    t.integer "compression",                                                  unsigned: true
    t.string  "compressedprimary"
    t.integer "attrs",                              default: 0,  null: false
    t.index ["gameid"], name: "gameid", using: :btree
  end

  create_table "gameprofilelinks", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string   "gameid",  limit: 32, default: "", null: false
    t.string   "userid",  limit: 32, default: "", null: false
    t.datetime "moddate"
    t.index ["gameid"], name: "gameid", using: :btree
    t.index ["userid"], name: "userid", using: :btree
  end

  create_table "games", id: :string, limit: 32, default: "", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.text     "title",         limit: 16777215,              null: false
    t.text     "author",        limit: 16777215,              null: false
    t.text     "authorExt",     limit: 16777215
    t.text     "sort_title",    limit: 16777215,              null: false
    t.text     "sort_author",   limit: 16777215,              null: false
    t.text     "tags",          limit: 16777215
    t.datetime "published"
    t.string   "version"
    t.string   "license",       limit: 32
    t.string   "system"
    t.string   "language",      limit: 16
    t.text     "desc",          limit: 65535
    t.string   "coverart",      limit: 64
    t.string   "seriesname",    limit: 128
    t.string   "seriesnumber",  limit: 32
    t.string   "genre"
    t.string   "forgiveness",   limit: 64
    t.integer  "bafsid"
    t.string   "website"
    t.string   "downloadnotes"
    t.datetime "created",                                     null: false
    t.string   "editedby",      limit: 32,       default: "", null: false
    t.datetime "moddate",                                     null: false
    t.bigint   "pagevsn",                        default: 0,  null: false
    t.index ["created"], name: "created", using: :btree
    t.index ["seriesname"], name: "seriesname", using: :btree
    t.index ["title", "author", "desc", "tags"], name: "title", type: :fulltext
    t.index ["title"], name: "title_2", type: :fulltext
  end

  create_table "games_history", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string   "id",       limit: 32,    default: "", null: false
    t.string   "editedby", limit: 32,    default: "", null: false
    t.datetime "moddate"
    t.bigint   "pagevsn"
    t.binary   "deltas",   limit: 65535,              null: false
    t.index ["id"], name: "id", using: :btree
  end

  create_table "gametags", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string   "gameid",  limit: 32, default: "",                         null: false
    t.string   "userid",  limit: 32, default: "",                         null: false
    t.string   "tag",                default: "",                         null: false
    t.datetime "moddate",            default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["gameid"], name: "gameid", using: :btree
    t.index ["tag"], name: "tag", using: :btree
    t.index ["userid"], name: "userid", using: :btree
  end

  create_table "gamexrefs", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string  "fromid",       limit: 32, null: false
    t.string  "toid",         limit: 32, null: false
    t.integer "reftype",                 null: false
    t.integer "displayorder"
    t.index ["fromid"], name: "fromid", using: :btree
    t.index ["toid"], name: "toid", using: :btree
  end

  create_table "gamexreftypes", primary_key: "reftype", id: :integer, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string "fromname", limit: 256, null: false
    t.string "toname",   limit: 256, null: false
    t.string "tonames",  limit: 256, null: false
  end

  create_table "ifids", primary_key: "ifid", id: :string, limit: 64, default: "", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string "gameid", limit: 32, default: "", null: false
    t.index ["gameid"], name: "gameid", using: :btree
  end

  create_table "iso639", primary_key: "isoid", id: :string, limit: 3, default: "", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string "name", limit: 128, default: "", null: false
  end

  create_table "iso639x", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string "id2",  limit: 2
    t.string "id3",  limit: 3
    t.string "name"
    t.index ["id2"], name: "index_1", using: :btree
    t.index ["id3"], name: "index_2", using: :btree
  end

  create_table "mirrors", primary_key: "mirrorid", unsigned: true, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string "baseurl", default: "", null: false
    t.string "name",    default: "", null: false
  end

  create_table "news", primary_key: "newsid", id: :bigint, unsigned: true, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string   "source",     limit: 1,        null: false
    t.string   "sourceid",   limit: 32,       null: false
    t.datetime "created",                     null: false
    t.datetime "modified"
    t.string   "userid",     limit: 32,       null: false
    t.bigint   "supersedes"
    t.bigint   "original"
    t.string   "status",     limit: 1
    t.text     "headline",   limit: 16777215
    t.text     "body",       limit: 16777215
    t.index ["sourceid"], name: "sourceid", using: :btree
    t.index ["userid"], name: "userid", using: :btree
  end

  create_table "operatingsystems", unsigned: true, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string  "externid",        limit: 32,       default: "", null: false
    t.string  "name",            limit: 128,      default: "", null: false
    t.binary  "icon",            limit: 16777215
    t.integer "displaypriority",                  default: 0,  null: false
  end

  create_table "osversions", primary_key: "vsnid", unsigned: true, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string  "externid",          limit: 32,       default: "", null: false
    t.integer "osid",                               default: 0,  null: false, unsigned: true
    t.integer "seq",                                default: 0,  null: false, unsigned: true
    t.string  "name",              limit: 128,      default: "", null: false
    t.text    "browserid",         limit: 16777215
    t.text    "dlinstructions",    limit: 16777215
    t.text    "dlruninstructions", limit: 16777215
    t.text    "runinstructions",   limit: 16777215
  end

  create_table "playedgames", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string   "userid",     limit: 32, default: "", null: false
    t.string   "gameid",     limit: 32, default: "", null: false
    t.datetime "date_added"
    t.index ["gameid"], name: "gameid", using: :btree
    t.index ["userid"], name: "userid", using: :btree
  end

  create_table "pollcomments", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string "pollid",   limit: 32,       default: "", null: false
    t.string "gameid",   limit: 32,       default: "", null: false
    t.text   "comments", limit: 16777215
    t.index ["gameid"], name: "gameid", using: :btree
    t.index ["pollid"], name: "pollid", using: :btree
  end

  create_table "polls", primary_key: "pollid", id: :string, limit: 32, default: "", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string   "title",                     default: "", null: false
    t.text     "keywords", limit: 16777215
    t.text     "desc",     limit: 16777215
    t.datetime "created"
    t.string   "userid",   limit: 32,       default: "", null: false
    t.index ["created"], name: "created", using: :btree
    t.index ["title", "keywords"], name: "title", type: :fulltext
  end

  create_table "pollvotes", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string   "pollid",     limit: 32,       default: "", null: false
    t.string   "gameid",     limit: 32,       default: "", null: false
    t.string   "userid",     limit: 32,       default: "", null: false
    t.string   "quickquote"
    t.text     "notes",      limit: 16777215
    t.datetime "votedate"
    t.index ["gameid"], name: "gameid", using: :btree
    t.index ["pollid"], name: "pollid", using: :btree
    t.index ["userid"], name: "userid", using: :btree
    t.index ["votedate"], name: "votedate", using: :btree
  end

  create_table "reclistitems", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string  "listid",       limit: 32,    default: "", null: false
    t.string  "gameid",       limit: 32,    default: "", null: false
    t.text    "comments",     limit: 65535
    t.integer "displayorder",               default: 0,  null: false
    t.index ["gameid"], name: "gameid", using: :btree
    t.index ["listid"], name: "listid", using: :btree
  end

  create_table "reclists", id: :string, limit: 32, default: "", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string   "title",      limit: 128,      default: "",                         null: false
    t.text     "keywords",   limit: 16777215
    t.text     "desc",       limit: 65535
    t.string   "userid",     limit: 32,       default: "",                         null: false
    t.datetime "createdate",                                                       null: false
    t.datetime "moddate",                     default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["title", "keywords"], name: "title", type: :fulltext
    t.index ["userid"], name: "userid", using: :btree
  end

  create_table "reviews", id: :bigint, unsigned: true, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string   "summary",     limit: 80
    t.text     "review",      limit: 65535
    t.integer  "rating",      limit: 1,                                                       unsigned: true
    t.string   "userid",      limit: 32,    default: "",                         null: false
    t.datetime "createdate",                                                     null: false
    t.datetime "moddate",                   default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.date     "embargodate"
    t.integer  "special",                                                                     unsigned: true
    t.string   "gameid",      limit: 32,    default: "",                         null: false
    t.integer  "RFlags",                    default: 0,                          null: false
    t.index ["createdate"], name: "createdate", using: :btree
    t.index ["gameid"], name: "gameid", using: :btree
    t.index ["userid"], name: "userid", using: :btree
  end

  create_table "reviewtags", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.bigint "reviewid", default: 0,  null: false, unsigned: true
    t.string "tag",      default: "", null: false
    t.index ["reviewid"], name: "reviewid", using: :btree
    t.index ["tag"], name: "tag", using: :btree
  end

  create_table "reviewvotes", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.bigint "reviewid",           default: 0,  null: false
    t.string "vote",     limit: 1, default: "", null: false
    t.index ["reviewid"], name: "reviewid", using: :btree
  end

  create_table "sitenews", primary_key: "itemid", id: :bigint, unsigned: true, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.text     "title",  limit: 16777215, null: false
    t.text     "ldesc",  limit: 16777215, null: false
    t.datetime "posted",                  null: false
    t.index ["posted"], name: "posted", using: :btree
  end

  create_table "specialreviewers", id: :integer, default: 0, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string  "code",              limit: 16, default: "",    null: false
    t.string  "name",              limit: 64, default: "",    null: false
    t.integer "displayrank",                  default: 0,     null: false
    t.boolean "editorial",                    default: false, null: false
    t.string  "requiredprivilege", limit: 1
  end

  create_table "stylesheets", primary_key: "stylesheetid", id: :bigint, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.text     "title",    limit: 16777215,                                      null: false
    t.string   "userid",   limit: 32,       default: "",                         null: false
    t.text     "desc",     limit: 16777215
    t.text     "contents", limit: 16777215
    t.datetime "created"
    t.datetime "modified",                  default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "tagstats", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.bigint "cnt", default: 0,  null: false
    t.string "tag", default: "", null: false
  end

  create_table "ucomments", primary_key: "commentid", id: :bigint, unsigned: true, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.bigint   "parent",                                 unsigned: true
    t.string   "source",   limit: 1,        null: false
    t.string   "sourceid", limit: 32,       null: false
    t.string   "userid",   limit: 32,       null: false
    t.text     "comment",  limit: 16777215
    t.datetime "created",                   null: false
    t.datetime "modified"
    t.index ["created"], name: "created", using: :btree
    t.index ["sourceid"], name: "reviewid", using: :btree
    t.index ["userid"], name: "userid", using: :btree
  end

  create_table "unwishlists", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string   "gameid",     limit: 32, null: false
    t.string   "userid",     limit: 32, null: false
    t.datetime "date_added",            null: false
    t.index ["gameid"], name: "gameid", using: :btree
    t.index ["userid"], name: "userid", using: :btree
  end

  create_table "users", id: :string, limit: 32, default: "", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string   "name",        limit: 128,   default: "", null: false
    t.string   "gender",      limit: 1
    t.string   "publicemail"
    t.string   "location",    limit: 128,   default: "", null: false
    t.text     "profile",     limit: 65535
    t.string   "picture",     limit: 64
    t.datetime "created"
    t.index ["name"], name: "name", unique: true, using: :btree
    t.index ["name"], name: "name_2", type: :fulltext
  end

  create_table "wishlists", id: false, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci" do |t|
    t.string   "gameid",     limit: 32, default: "", null: false
    t.string   "userid",     limit: 32, default: "", null: false
    t.datetime "date_added"
    t.index ["gameid"], name: "gameid", using: :btree
    t.index ["userid"], name: "userid", using: :btree
  end

end
