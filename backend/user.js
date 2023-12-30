const express = require('express');
const router = express.Router();
const db = require('./db');

router.route('/register').post((req, res) => {
    var firstName = req.body.firstName;
    var lastName = req.body.lastName;
    var email = req.body.email;
    var countryCode = req.body.countryCode;
    var mobileNumber = req.body.mobileNumber;
    var username = req.body.username;
    var password = req.body.password;
    
    var sqlCheckUsername = "SELECT * FROM users WHERE username = ?";
    db.query(sqlCheckUsername, [username], function (error, data, fields) {
        if (error) {
            res.send(JSON.stringify({ success: false, message: error }));
        } else if (data.length > 0) {
            // Username already exists
            res.send(JSON.stringify({ success: false, message: 'Username already exists' }));
        } else {
            var sqlCheckMobile = "SELECT * FROM users WHERE mobileNumber = ?";
            db.query(sqlCheckMobile, [mobileNumber], function (error, data, fields) {
                if (error) {
                    res.send(JSON.stringify({ success: false, message: error }));
                } else if (data.length > 0) {
                    // Mobile number already exists
                    res.send(JSON.stringify({ success: false, message: 'Mobile number already exists' }));
                } else {
                    var sqlCheckEmail = "SELECT * FROM users WHERE email = ?";
                    db.query(sqlCheckEmail, [email], function (error, data, fields) {
                        if (error) {
                            res.send(JSON.stringify({ success: false, message: error }));
                        } else if (data.length > 0) {
                            // Email already exists
                            res.send(JSON.stringify({ success: false, message: 'Email already exists' }));
                        } else {
                            // All checks passed, insert new user
                            var sqlInsert = "INSERT INTO users(firstName, lastName, email, countryCode, mobileNumber, username, password) VALUES (?, ?, ?, ?, ?, ?, ?)";
                            var sqlSelect = "SELECT userId FROM users WHERE mobileNumber = ?";
                            db.query(sqlInsert, [firstName, lastName, email, countryCode, mobileNumber, username, password], function (error, data, fields) {
                                if (error) {
                                    res.send(JSON.stringify({ success: false, message: error }));
                                } else {
                                    db.query(sqlSelect, [mobileNumber], function (error, data, fields) {
                                        var userId = data[0].userId;
                                        res.send(JSON.stringify({ success: true, message: 'Register', userId: userId }));
                                    });
                                }
                            });
                        }
                    });
                }
            });
        }
    });
});


router.route('/login').post((req, res) => {
    var mobileNumber = req.body.mobileNumber;
    var password = req.body.password;

    var sql = "select userId from users where mobileNumber=? and password =?";

    db.query(sql, [mobileNumber, password], function (err, results) {
        if (err) {
            console.error('Error executing query:', err);
            return res.status(500).json({ error: 'Internal Server Error' });
        }

        if (results.length > 0) {
            const user = results[0]; // Assuming only one user for a given mobileNumber/password

            return res.status(200).json({
                message: 'Login successful',
                userId: user.userId
            });
        } else {
            // User authentication failed
            return res.status(401).json({ error: 'Invalid credentials' });
        }
    });
});

router.route('/profile/:userId').get((req, res) => {
    const userId = req.params.userId;

    const followersQuery = 'SELECT COUNT(*) AS followers FROM followers WHERE userId = ?';
    const followingQuery = 'SELECT COUNT(*) AS following FROM followers WHERE followerUserId = ?';
    const userQuery = 'SELECT username, firstName, lastName, countryCode, mobileNumber, email, dateOfBirth, category, businessName, services, bio, city, state, country, twitterurl, igurl, linkedinurl, profilepicurl FROM users WHERE userId = ?';

    db.query(followersQuery, [userId], (error, followersResults) => {
      if (error) {
        return res.status(500).json({ error: 'Internal Server Error' });
      }
  
      db.query(followingQuery, [userId], (error, followingResults) => {
        if (error) {
          return res.status(500).json({ error: 'Internal Server Error' });
        }
        db.query(userQuery, [userId], (error, userResults) => {
            if (error) {
                return res.status(500).json({ error: 'Internal Server Error' });
            }
        const followersCount = followersResults[0].followers;
        const followingCount = followingResults[0].following;
        const username = userResults[0].username;
        const firstName = userResults[0].firstName;
        const lastName = userResults[0].lastName;
        const countryCode = userResults[0].countryCode;
        const mobileNumber = userResults[0].mobileNumber;
        const email = userResults[0].email;
        const dateOfBirth = userResults[0].dateOfBirth;
        const category = userResults[0].category;
        const businessName = userResults[0].businessName;
        const services = userResults[0].services;
        const bio = userResults[0].bio;
        const state = userResults[0].state;
        const city = userResults[0].city;
        const country = userResults[0].country;
        const twitterurl = userResults[0].twitterurl;
        const igurl = userResults[0].igurl;
        const linkedinurl = userResults[0].linkedinurl;
        const profilepicurl = userResults[0].profilepicurl;

        return res.status(200).json({
            followers: followersCount || 0,
            following: followingCount || 0,
            username: username || "",
            firstName: firstName || "",
            lastName: lastName || "",
            countryCode: countryCode || "",
            mobileNumber: mobileNumber || "",
            email: email || "",
            dateOfBirth: dateOfBirth || "",
            category: category || "",
            businessName: businessName || "",
            services: services || "",
            bio: bio || "",
            state: state || "",
            city: city || "",
            country: country || "",
            twitterurl: twitterurl || "",
            igurl: igurl || "",
            linkedinurl: linkedinurl || "",
            profilepicurl: profilepicurl || "",
          });
      });
    });
  });
});



router.route('/update/:userId').post((req,res)=>{
    const userId = req.params.userId;

    var firstName = req.body.firstName;
    var lastName = req.body.lastName;
    var email = req.body.email;
    var countryCode = req.body.countryCode;
    var mobileNumber = req.body.mobileNumber;
    var username = req.body.username;
    var country = req.body.country;
    var state = req.body.state;
    var city = req.body.city;
    var dateOfBirth = req.body.dateOfBirth;
    var category = req.body.category;
    var bio = req.body.bio;
    var services = req.body.services;
    var businessName = req.body.businessName;
    var twitterurl = req.body.twitterurl;
    var igurl = req.body.igurl;
    var linkedinurl = req.body.linkedinurl;
    var profilepicurl = req.body.profilepicurl;

    var sqlquery = "update users set firstName=?,lastName=?, email=?, countryCode=?, mobileNumber=?, username=?, city=?, state=?, country=?, dateOfBirth=?, bio=?, services=?, category=?, businessName=?, linkedinurl=?, twitterurl=?, igurl=?, profilepicurl=? where userId=?";

    db.query(sqlquery,[firstName, lastName, email, countryCode, mobileNumber, username, city, state, country, dateOfBirth, bio, services, category, businessName,linkedinurl, twitterurl, igurl, profilepicurl, userId], function(error, data, fields){
        if(error){
            res.send(JSON.stringify({success:false, message:error}));
        }
        else{
            res.send(JSON.stringify({ message: 'Updated Successfully'}));
        }
    });
});

router.route('/followers/:userId').get((req, res) => {
    const userId = req.params.userId;
    const followersQuery = 'SELECT username, profilepicurl FROM followers INNER JOIN users ON followers.followerUserId = users.userId WHERE followers.userId = ?';

    db.query(followersQuery, [userId], (error, results) => {
        if (error) {
            return res.status(500).json({ error: 'Internal Server Error' });
        }

        const followersList = results.map(result => ({
            username: result.username,
            profilepicurl: result.profilepicurl
        }));
        res.status(200).json({followersList });
    });
});

router.route('/following/:userId').get((req, res) => {
    const userId = req.params.userId;
    const followersQuery = 'SELECT username, profilepicurl FROM followers INNER JOIN users ON followers.UserId = users.userId WHERE followers.followeruserId = ?';

    db.query(followersQuery, [userId], (error, results) => {
        if (error) {
            return res.status(500).json({ error: 'Internal Server Error' });
        }

        const followersList = results.map(result => ({
            username: result.username,
            profilepicurl: result.profilepicurl
        }));
        res.status(200).json({followersList });
    });
});


router.route('/userprofilefollowers/:username').get((req, res) => {
    const username = req.params.username;

    const userIdquery= 'select userid from users where username=?';

    db.query(userIdquery, [username], (error, results, fields) => {
            const userId = results[0].userid;
    const followersQuery = 'SELECT username, profilepicurl FROM followers INNER JOIN users ON followers.followerUserId = users.userId WHERE followers.userId = ?';

    db.query(followersQuery, [userId], (error, results) => {
        if (error) {
            return res.status(500).json({ error: 'Internal Server Error' });
        }

        const followersList = results.map(result => ({
            username: result.username,
            profilepicurl: result.profilepicurl || "",
        }));
        res.status(200).json({followersList });
    });
});
});

router.route('/userprofilefollowing/:username').get((req, res) => {
    const requestedUsername = req.params.username;

    const userIdQuery = 'SELECT userid FROM users WHERE username=?';

    db.query(userIdQuery, [requestedUsername], (error, results, fields) => {
        const userId = results[0].userid;
        const followersQuery = 'SELECT username, profilepicurl FROM followers INNER JOIN users ON followers.UserId = users.userId WHERE followers.followeruserId = ?';

        db.query(followersQuery, [userId], (error, results) => {
            if (error) {
                return res.status(500).json({ error: 'Internal Server Error' });
            }

            const followersList = results.map(result => ({
                username: result.username,
                profilepicurl: result.profilepicurl || "",
            }));
            res.status(200).json({followersList });
        });
    });
});

router.route('/userprofile/:username').get((req, res) => {
    const username = req.params.username;

    const userIdquery= 'select userid from users where username=?';

    db.query(userIdquery, [username], (error, results, fields) => {
            const userId = results[0].userid;
        

    const followersQuery = 'SELECT COUNT(*) AS followers FROM followers WHERE userid = ?';
    const followingQuery = 'SELECT COUNT(*) AS following FROM followers WHERE followerUserId = ?';
    const userQuery = 'SELECT firstName, lastName, email, category, businessName, services, bio, city, state, country, twitterurl, igurl, linkedinurl, profilepicurl FROM users WHERE userId = ?';

    db.query(followersQuery, [userId], (error, followersResults) => {
      if (error) {
        return res.status(500).json({ error: 'Internal Server Error' });
      }
  
      db.query(followingQuery, [userId], (error, followingResults) => {
        if (error) {
          return res.status(500).json({ error: 'Internal Server Error' });
        }
        db.query(userQuery, [userId], (error, userResults) => {
            if (error) {
                return res.status(500).json({ error: 'Internal Server Error' });
            }

        const followersCount = followersResults[0].followers;
        const followingCount = followingResults[0].following;
        const firstName = userResults[0].firstName;
        const lastName = userResults[0].lastName;
        const email = userResults[0].email;
        const category = userResults[0].category;
        const businessName = userResults[0].businessName;
        const services = userResults[0].services;
        const bio = userResults[0].bio;
        const state = userResults[0].state;
        const city = userResults[0].city;
        const country = userResults[0].country;
        const twitterurl = userResults[0].twitterurl;
        const igurl = userResults[0].igurl;
        const linkedinurl = userResults[0].linkedinurl;
        const profilepicurl = userResults[0].profilepicurl;

        return res.status(200).json({
            followers: followersCount || 0,
            following: followingCount || 0,
            firstName: firstName || "",
            lastName: lastName || "",
            email: email || "",
            category: category || "",
            businessName: businessName || "",
            services: services || "",
            bio: bio || "",
            state: state || "",
            city: city || "",
            country: country || "",
            twitterurl: twitterurl || "",
            igurl: igurl || "",
            linkedinurl: linkedinurl || "",
            profilepicurl: profilepicurl || "",
            userId: userId || "",
          });
      });
    });
  });
});
});

router.route('/post').post((req, res) => {
    const userId = req.body.userId;
    var caption = req.body.caption;
    var imageurl = req.body.imageurl;

    const postQuery = 'insert into posts (userid, caption, imageurl) values(?,?,?)';

    db.query(postQuery, [userId, caption, imageurl], (error, results) => {
        if (error) {
            return res.status(500).json({ error: 'Internal Server Error' });
        }
        res.status(200).json({ success:true, message:"Posted successfully" });
    });
});

router.route('/loadposts/:userId').get((req, res) => {
  const userId = req.params.userId;

  const query = `
  SELECT 
  users_posted.profilepicurl AS profilepicurl,
  users_posted.username AS username,
  posts.caption,
  posts.imageurl,
  posts.postId,
  (CASE WHEN likes.userId IS NOT NULL THEN 1 ELSE 0 END) AS isLiked,
  COUNT(likes.likeId) AS likeCount
FROM 
  followers
JOIN 
  users AS users_following ON followers.followerUserId = users_following.userId
JOIN 
  posts ON followers.userId = posts.userId
JOIN
  users AS users_posted ON posts.userId = users_posted.userId  -- Added this line
LEFT JOIN
  likes ON posts.postId = likes.postId AND likes.userId = ?
WHERE 
  followers.followerUserId = ?
GROUP BY
  posts.postId
ORDER BY 
  posts.postDate DESC;

  `;


  db.query(query, [userId, userId], (error, results) => {
    if (error) {
      console.error(error);
      return res.status(500).json({ error: 'Internal Server Error'});
    }

    res.status(200).json({ posts: results });
  });
});

router.route('/toggleLike/:postId').post((req, res) => {
  const { postId } = req.params;
  const { userIds, isLiked } = req.body;
  const userId = parseInt(userIds, 10);
  const isLikedValue = isLiked === '0';

  const query = isLikedValue
    ? 'DELETE FROM likes WHERE postId = ? AND userId = ?'
    : 'INSERT INTO likes (postId, userId) VALUES (?, ?)';

  db.query(query, [postId, userId], (err, result) => {
    if (err) {
      console.error('Error toggling like status: ' + err.stack);
      res.status(500).send('Internal Server Error');
      return;
    }

    // Check if a like was added
    if (!isLikedValue) {
      // Get the post owner's userId
      const getPostOwnerQuery = 'SELECT userId FROM posts WHERE postId = ?';
      db.query(getPostOwnerQuery, [postId], (err, result) => {
        if (err) {
          console.error('Error getting post owner: ' + err.stack);
          res.status(500).send('Internal Server Error');
          return;
        }

        const postOwnerId = result[0].userId;

        // Get the username of the user who liked the post
        const getLikerUsernameQuery = 'SELECT username FROM users WHERE userId = ?';
        db.query(getLikerUsernameQuery, [userId], (err, result) => {
          if (err) {
            console.error('Error getting liker username: ' + err.stack);
            res.status(500).send('Internal Server Error');
            return;
          }

          const likerUsername = result[0].username;

          // Insert a notification for the post owner
          const notificationText = `${likerUsername} liked your post.`;
          const insertNotificationQuery = 'INSERT INTO notifications (userId, notificationText) VALUES (?, ?)';
          db.query(insertNotificationQuery, [postOwnerId, notificationText], (err, result) => {
            if (err) {
              console.error('Error inserting notification: ' + err.stack);
              res.status(500).send('Internal Server Error');
              return;
            }

            res.status(200).json({ success: true });
          });
        });
      });
    } else {
      res.status(200).json({ success: true });
    }
  });
});



  router.route('/loaduserposts/:username').get((req, res) => {
    const username = req.params.username;

    const userIdquery= 'select userid from users where username=?';

    db.query(userIdquery, [username], (error, results, fields) => {
            const userId = results[0].userid;
            const query = `
    SELECT 
      users.profilepicurl,
      users.username,
      posts.caption,
      posts.imageurl,
      posts.postId,
      (CASE WHEN likes.userId IS NOT NULL THEN 1 ELSE 0 END) AS isLiked,
      COUNT(likes.likeId) AS likeCount
    FROM 
      users
    LEFT JOIN 
      posts ON users.userId = posts.userId
    LEFT JOIN
      likes ON posts.postId = likes.postId AND likes.userId = ?
    WHERE 
      users.userId = ?
    GROUP BY
      posts.postId
    ORDER BY 
      posts.postDate DESC;
  `;

  
    db.query(query, [userId, userId], (error, results) => {
      if (error) {
        console.error(error);
        return res.status(500).json({ error: 'Internal Server Error'});
      }
  
      res.status(200).json({ posts : results });
    });
  });
});

router.route('/loadcurrentuserposts/:userId').get((req, res) => {
  const userId = req.params.userId;
  const query = `
    SELECT 
      users.profilepicurl,
      users.username,
      posts.caption,
      posts.imageurl,
      posts.postId,
      (CASE WHEN likes.userId IS NOT NULL THEN 1 ELSE 0 END) AS isLiked,
      COUNT(likes.likeId) AS likeCount
    FROM 
      users
    LEFT JOIN 
      posts ON users.userId = posts.userId
    LEFT JOIN
      likes ON posts.postId = likes.postId AND likes.userId = ?
    WHERE 
      users.userId = ?
    GROUP BY
      posts.postId
    ORDER BY 
      posts.postDate DESC;
  `;


  db.query(query, [userId, userId], (error, results) => {
    if (error) {
      console.error(error);
      return res.status(500).json({ error: 'Internal Server Error'});
    }

    res.status(200).json({ posts : results });
  });
});

  router.route('/checkfollowing/:currentUserId').get((req, res) => {
    const currentUserId = req.params.currentUserId;
    const userId = req.query.userId;
  
    const checkFollowingQuery = `
      SELECT * FROM followers
      WHERE userId = ? AND followerUserId = ?
    `;
  
    db.query(checkFollowingQuery, [userId, currentUserId], (err, result) => {
        if (result.length > 0) {
          res.send('yes');
        } else {
          res.send('no');
        }
    });
  });

  router.route('/unfollowuser/:currentUserId').get((req, res) => {
    const currentUserId = req.params.currentUserId;
    const userId = req.query.userId;
  
    const unfollowuserquery = `
      Delete from followers where userId=? and followerUserId=?
    `;
  
    db.query(unfollowuserquery, [userId, currentUserId], (err, result) => {
          res.send('yes');
    });
  });
  
  router.route('/followuser/:currentUserId').get((req, res) => {
    const currentUserId = req.params.currentUserId;
    const userId = req.query.userId;

    const userIdquery = 'SELECT username FROM users WHERE userid=?';

    db.query(userIdquery, [userId], (error, results, fields) => {
        const username = results[0].username;

        const currentUsernameQuery = 'SELECT username FROM users WHERE userid=?';

        db.query(currentUsernameQuery, [currentUserId], (error, results, fields) => {
            const currentUsername = results[0].username;

            const followuserquery = `
                INSERT INTO followers (userId, followerUserId) VALUES (?, ?);
            `;

            const notificationTextFollowed = `You started following ${username}`;
            const notificationTextFollowing = `${currentUsername} started following you`;

            db.query(followuserquery, [userId, currentUserId], (err, result) => {
                if (err) {
                    console.error(err);
                    res.status(500).send('Internal Server Error');
                } else {
                    // Insert notification for the user who initiated the follow action
                    const insertNotificationFollowed = 'INSERT INTO notifications (userId, notificationText) VALUES (?, ?)';
                    db.query(insertNotificationFollowed, [currentUserId, notificationTextFollowed], (err, result) => {
                        if (err) {
                            console.error(err);
                            res.status(500).send('Internal Server Error');
                        } else {
                            // Insert notification for the user who is being followed
                            const insertNotificationFollowing = 'INSERT INTO notifications (userId, notificationText) VALUES (?, ?)';
                            db.query(insertNotificationFollowing, [userId, notificationTextFollowing], (err, result) => {
                                if (err) {
                                    console.error(err);
                                    res.status(500).send('Internal Server Error');
                                } else {
                                    res.send('yes');
                                }
                            });
                        }
                    });
                }
            });
        });
    });
});

router.route('/recentmessages/:userId').get((req, res) => {
    const userId = req.params.userId;

    const query = `
      SELECT senderId, MAX(sendDate) as mostRecentDate, messageText
      FROM messages
      WHERE receiverId = ?
      GROUP BY senderId;
    `;

    db.query(query, [userId], (err, result) => {
      if (err) {
        res.status(500).send(err);
      } else {
        res.status(200).json({ messages: result });
      }
    });
  });


  router.route('/loadmessages/:userId/:receiverId').get((req, res) => {
    const { userId, receiverId } = req.params;
    const query = `SELECT * FROM messages WHERE (senderId = ${userId} AND receiverId = ${receiverId}) OR (senderId = ${receiverId} AND receiverId = ${userId}) ORDER BY sendDate DESC`;
    db.query(query, (err, result) => {
      if (err) {
        res.status(500).send(err);
      } else {
        res.status(200).json({ messages: result });
      }
    });
  });
  
  router.route('/sendmessage').post((req, res) => {
    const { userId, receiverId, messageText } = req.body;
    const query = `INSERT INTO messages (senderId, receiverId, messageText) VALUES (?, ?, ?)`;
    
    db.query(query, [userId, receiverId, messageText], (err, result) => {
        if (err) {
            res.status(500).send('Internal Server Error');
        } else {
            res.status(201).send();
        }
    });
});

  router.route('/loaduseridfromusername/:username').get((req, res) => {
    const username = req.params.username;
    const query = 'SELECT userId FROM users WHERE username=?';
  
    db.query(query, [username], function (error, results) {
      if (error) {
        res.status(500).send(error);
      } else {
        res.status(200).json({ receiverId: results });
      }
    });
  });

  router.route('/checkEmail/:email').get((req, res) => {
    const email = req.params.email; 
    const query = 'SELECT COUNT(*) AS count FROM users WHERE email = ?';
  
    db.query(query, [email], (err, result) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: 'Internal Server Error' });
      }
  
      const count = result[0].count;
  
      if (count > 0) {
        res.json({ exists: true });
      } else {
        res.json({ exists: false });
      }
    });
  });

  router.route('/loadnotifications/:userId').get((req, res) => {
    const userId = req.params.userId;
  
    const query = `
      SELECT * FROM notifications
      WHERE userId = ?
      ORDER BY creationDate DESC;
    `;
  
    db.query(query, [userId], (err, results) => {
      if (err) {
        res.status(500).send('Internal Server Error');
      } else {
        res.json(results);
      }
    });
  });

  router.route('/loadsearchpageusers/:userId').get((req, res) => {
    const userId = req.params.userId;
    const category = req.query.category;

    if (category === 'All') {
        const query = `
            SELECT users.username, users.profilepicurl, COUNT(follower.userId) AS followersCount
            FROM users
            LEFT JOIN (
                SELECT userId, followerUserId
                FROM followers
                WHERE followerUserId = ?
            ) AS follower ON users.userId = follower.userId
            WHERE users.userId != ? AND follower.userId IS NULL
            GROUP BY users.userId
            ORDER BY followersCount DESC;
        `;

        db.query(query, [userId, userId], (err, results) => {
            if (err) {
                console.error(err);
                res.status(500).send('Internal Server Error');
            } else {
                res.json(results);
            }
        });
    } else if (category) {
        const query = `
            SELECT u.*, COUNT(f.followerId) AS followerCount
            FROM Users u
            LEFT JOIN Followers f ON u.userId = f.userId
            WHERE u.category = ?
            GROUP BY u.userId
            ORDER BY followerCount DESC;
        `;

        db.query(query, [category], (err, results) => {
            if (err) {
                console.error(err);
                res.status(500).send('Internal Server Error');
            } else {
                res.json(results);
            }
        });
    } else {
        const query = `
            SELECT users.username, users.profilepicurl, COUNT(follower.userId) AS followersCount
            FROM users
            LEFT JOIN (
                SELECT userId, followerUserId
                FROM followers
                WHERE followerUserId = ?
            ) AS follower ON users.userId = follower.userId
            WHERE users.userId != ? AND follower.userId IS NULL
            GROUP BY users.userId
            ORDER BY followersCount DESC;
        `;

        db.query(query, [userId, userId], (err, results) => {
            if (err) {
                console.error(err);
                res.status(500).send('Internal Server Error');
            } else {
                res.json(results);
            }
        });
    }
});

router.route('/loadcomments/:postId').get((req, res) => {
  const postId = req.params.postId;

  const query = `
  SELECT
  c.commentId,
  c.userId,
  c.postId,
  c.commentText,
  DATE_FORMAT(c.commentDate, '%m-%Y') commentDate,
  u.username,
  u.profilepicurl
FROM
  comments c
JOIN users u ON c.userId = u.userId
WHERE
  c.postId = ?;

  `;
  db.query(query, [postId], (error, results) => {
    if (error) {
      res.status(500).json({ error: 'Internal Server Error' });
    } else {
      res.status(200).json(results);
    }
  });
});

router.route('/postcomment').post((req, res) => {
  const { userId, postId, commentText } = req.body;
  const query = 'INSERT INTO comments (userId, postId, commentText) VALUES (?, ?, ?)';

  db.query(query, [userId, postId, commentText], (err) => {
    if (err) {
      res.status(500).send('Internal Server Error');
    } else {
      // Get the post owner's userId
      const getPostOwnerQuery = 'SELECT userId FROM posts WHERE postId = ?';
      db.query(getPostOwnerQuery, [postId], (err, result) => {
        if (err) {
          console.error('Error getting post owner: ' + err.stack);
          res.status(500).send('Internal Server Error');
          return;
        }

        const postOwnerId = result[0].userId;

        // Get the username of the user who posted the comment
        const getCommenterUsernameQuery = 'SELECT username FROM users WHERE userId = ?';
        db.query(getCommenterUsernameQuery, [userId], (err, result) => {
          if (err) {
            console.error('Error getting commenter username: ' + err.stack);
            res.status(500).send('Internal Server Error');
            return;
          }

          const commenterUsername = result[0].username;

          // Insert a notification for the post owner
          const notificationText = `${commenterUsername} commented on your post.`;
          const insertNotificationQuery = 'INSERT INTO notifications (userId, notificationText) VALUES (?, ?)';
          db.query(insertNotificationQuery, [postOwnerId, notificationText], (err, result) => {
            if (err) {
              console.error('Error inserting notification: ' + err.stack);
              res.status(500).send('Internal Server Error');
              return;
            }

            res.status(200).send();
          });
        });
      });
    }
  });
});


router.route('/deletecomment/:commentId').post((req, res) => {
  const commentId = req.params.commentId;
  const query = 'Delete from comments where commentId=?';
  
  db.query(query, [commentId], (err) => {
    if (err) {
      res.status(500).send('Internal Server Error');
    } else {
      res.status(200).send();
    }
  });
});

  module.exports = router;
