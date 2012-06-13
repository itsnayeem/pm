var api = {
    url : "http://teamrecon.nayeem.co/",
    suc : function(response, success, error) {
        if (response.success) {
            success(response.data);
        } else {
            error(response.data);
        }
    },
    err : function (response, error) {
        error(response.data);
    },
    acct : {
        controller : "acct/",
        /**
         * acct/login
         * 
         * @param email required
         * @param password required
         */
        login : function (s, e, email, password) {
            data = {};
            if (email && password) {
                data.sign_in_username_email = email;
                data.sign_in_password = password;
            }
            $.post(api.url + api.acct.controller + "login",
                data, function (r) { 
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * acct/logout
         */
        logout : function (s, e) {
            $.post(api.url + api.acct.controller + "logout", {
                }, function (r) {
                    api.suc (r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * acct/register
         * 
         * @param email required
         * @param password required
         */
        register : function (s, e, email, password) {
            data = {};
            if (sign_up_email && sign_up_password) {
                data.sign_up_email = email;
                data.sign_up_password = password;
            } else {
                return false;
            }
            $.post(api.url + api.acct.controller + "register",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * acct/user
         * 
         * @param account_id optional
         */
        user : function (s, e, account_id) {
            data = {};
            if (account_id) {
                data.account_id = account_id;
            }
            $.getJSON(api.url + api.acct.controller + "user", 
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * acct/update_profile
         * 
         * @param data required
         *      fname, lname, birthday, gender, interested_in, profile_pic_url, plate_id
         */
        update_profile : function (s, e, data) {
            if ( ! data) {
                return false;
            }
            $.post(api.url + api.acct.controller + "update_profile",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * acct/change_password
         * 
         * @param password_new required
         */
        change_password : function (s, e, password_new) {
            data = {};
            if (password_new) {
                data.password_new = password_new;
            } else {
                return false;
            }
            $.post(api.url + api.acct.controller + "change_password",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * acct/forgot_password
         * 
         * @param email required
         */
        forgot_password : function (s, e, email) {
            data = {};
            if (email) {
                data.forgot_password_email = email;
            } else {
                return false;
            }
            $.post(api.url + api.acct.controller + "forgot_password",
                data, function (r) { 
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        }
    },
    plate : {
        controller : "plate/",
        /**
         * plate/get
         * 
         * @param plate_id[0] required[0]/optional[1]
         * @param plate[1] required[1]/optional[0]
         * @param state[1] required[1]/optional[0]
         */
        get : function (s, e, plate_id, plate, state) {
            data = {};
            if (plate_id) {
                data.plate_id = plate_id;
            } else if (plate && state) {
                data.plate = plate;
                data.state = state;
            } else {
                return false;
            }
            $.getJSON(api.url + api.plate.controller + "get",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * plate/get_by_account
         * 
         * @param account_id optional
         */
        get_by_account : function (s, e, account_id) {
            data = {};
            if (account_id) {
                data.account_id = account_id;
            }
            $.getJSON(api.url + api.plate.controller + "get_by_account",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * plate/get_wall
         * 
         * @param plate_id optional
         */
        get_wall : function (s, e, plate_id) {
            data = {};
            if (plate_id) {
                data.plate_id = plate_id;
            }
            $.getJSON(api.url + api.plate.controller + "get_wall",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * plate/update_plate
         * 
         * @param data required
         *      plate_id, account_id, make, model, color, year, state, access, plate_pic_url, lat, lon
         */
        update_plate : function (s, e, data) {
            if ( ! data) {
                return false;
            }
            $.post(api.url + api.plate.controller + "update_plate",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * plate/update_location
         * 
         * @param plate_id required
         * @param lat required/optional (defaults to 0)
         * @param lon required/optional (defaults to 0)
         */
        update_location : function (s, e, plate_id, lat, lon) {
            data = {};
            if (plate_id) {
                data.plate_id = plate_id;
                if ( ! lat) {
                    lat = 0;
                }
                data.lat = lat;
                if ( ! lon) {
                    lon = 0;
                }
                data.lon = lon;
            } else {
                return false;
            }
            $.post(api.url + api.plate.controller + "update_location",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * plate/post
         * 
         * @param plate_id required
         * @param content required
         * @param parent_id optional (defaults to 0)
         */
        post : function (s, e, plate_id, content, parent_id) {
            data = {};
            if (plate_id && content) {
                data.plate_id = plate_id;
                data.content = content;
                if ( ! parent_id) {
                    parent_id = 0;
                }
                data.parent_id = parent_id;
            } else {
                return false;
            }
            $.post(api.url + api.plate.controller + "post",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * plate/delete
         * 
         * @param wall_post_id required
         */
        "delete" : function (s, e, wall_post_id) {
            data = {};
            if (wall_post_id) {
                data.wall_post_id = wall_post_id;
            } else {
                return false;
            }
            $.post(api.url + api.plate.controller + "delete",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * plate/assoc_user
         * 
         * @param plate_id required
         */
        assoc_user : function (s, e, plate_id) {
            data = {};
            if (plate_id) {
                data.plate_id = plate_id;
            } else {
                return false;
            }
            $.post(api.url + api.plate.controller + "assoc_user",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        }
    },
    favorite : {
        controller : "favorite/",
        /**
         * favorite/add
         * 
         * @param target_id required
         */
        add : function (s, e, target_id) {
            data = {};
            if (target_id) {
                data.target_id = target_id;
            } else {
                return false;
            }
            $.post(api.url + api.favorite.controller + "add",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * favorite/confirm
         * 
         * @param target_id required
         * 
         */
        confirm : function (s, e, target_id) {
            data = {};
            if (target_id) {
                data.target_id = target_id;
            } else {
                return false;
            }
            $.post(api.url + api.favorite.controller + "confirm",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * favorite/remove
         * 
         * @param target_id required
         */
        remove : function (s, e, target_id) {
            data = {};
            if (target_id) {
                data.target_id = target_id;
            } else {
                return false;
            }
            $.post(api.url + api.favorite.controller + "remove",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * favorite/get
         * 
         * @param account_id optional
         */
        get : function (s, e, account_id) {
            data = {};
            if (account_id) {
                data.account_id = account_id;
            }
            $.getJSON(api.url + api.favorite.controller + "get",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * favorite/get_pending
         * 
         * @param account_id optional
         */
        get_pending : function (s, e, account_id) {
            data = {};
            if (account_id) {
                data.account_id = account_id;
            }
            $.getJSON(api.url + api.favorite.controller + "get_pending",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * favorite/check
         * 
         * @param favorite_id required
         * @param account_id optional
         */
        check : function (s, e, favorite_id, account_id) {
            data = {};
            if (favorite_id) {
                data.favorite_id = favorite_id;
                if (account_id) {
                    data.account_id = account_id;
                }
            } else {
                return false;
            }
            $.getJSON(api.url + api.favorite.controller + "get",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        }
    },
    follower : {
        controller : "follower/",
        /**
         * follower/add
         * 
         * @param plate_id required
         */
        add : function (s, e, plate_id) {
            data = {};
            if (target_id) {
                data.plate_id = plate_id;
            } else {
                return false;
            }
            $.post(api.url + api.follower.controller + "add",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * follower/remove
         * 
         * @param plate_id required
         */
        remove : function (s, e, plate_id) {
            data = {};
            if (plate_id) {
                data.plate_id = plate_id;
            } else {
                return false;
            }
            $.post(api.url + api.follower.controller + "remove",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * follower/get
         * 
         * @param account_id optional
         */
        get : function (s, e, account_id) {
            data = {};
            if (account_id) {
                data.account_id = account_id;
            }
            $.getJSON(api.url + api.follower.controller + "get",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * follower/check
         * 
         * @param plate_id required
         * @param account_id optional
         */
        check : function (s, e, plate_id, account_id) {
            data = {};
            if (plate_id) {
                data.plate_id = plate_id;
                if (account_id) {
                    data.account_id = account_id;
                }
            } else {
                return false;
            }
            $.getJSON(api.url + api.follower.controller + "get",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        }
    },
    five_star : {
        controller : "five_star/",
        /**
         * five_star/rate
         * 
         * @param wall_post_id required
         * @param rating required
         */
        rate : function (s, e, wall_post_id, rating) {
            data = {};
            if (wall_post_id && rating) {
                data.wall_post_id = wall_post_id;
                data.rating = rating;
            } else {
                return false;
            }
            $.post(api.url + api.five_star.controller + "rate",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * five_star/get
         * 
         * @param wall_post_id
         */
        get : function (s, e, wall_post_id) {
            data = {};
            if (wall_post_id) {
                data.wall_post_id = wall_post_id;
            } else {
                return false;
            }
            $.getJSON(api.url + api.five_star.controller + "get",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        } 
    },
    pm : {
        controller : "pm/",
        /**
         * pm/send
         * 
         * @param receiver_id required
         * @param content required
         */
        send : function (s, e, receiver_id, content) {
            data = {};
            if (receiver_id && content) {
                data.receiver_id = receiver_id;
                data.content = content;
            } else {
                return false;
            }
            $.post(api.url + api.pm.controller + "send",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        },
        /**
         * pm/get
         */
        get : function (s, e) {
            data = {};
            $.getJSON(api.url + api.pm.controller + "get",
                data, function (r) {
                    api.suc(r, s, e);
                }).error(function(r) {
                api.err(r,e)
            });
            return true;
        }
    }
    
}

