-- 1. Location of User 
SELECT * FROM post
WHERE location IN ('agra' ,'maharashtra','west bengal');

-- 2. Most Followed Hashtag
SELECT 
	hashtag_name AS 'Hashtags', COUNT(hashtag_follow.hashtag_id) AS 'Total Follows' 
FROM hashtag_follow, hashtags 
WHERE hashtags.hashtag_id = hashtag_follow.hashtag_id
GROUP BY hashtag_follow.hashtag_id
ORDER BY COUNT(hashtag_follow.hashtag_id) DESC LIMIT 5;


-- 3. Most Used Hashtags
SELECT 
	hashtag_name AS 'Trending Hashtags', 
    COUNT(post_tags.hashtag_id) AS 'Times Used'
FROM hashtags,post_tags
WHERE hashtags.hashtag_id = post_tags.hashtag_id
GROUP BY post_tags.hashtag_id
ORDER BY COUNT(post_tags.hashtag_id) DESC LIMIT 10;

-- 4. Most Inactive User
select user_id, username as 'most-inactive-users'
from users
where user_id not in (select user_id from post);

-- 5. Most Likes Posts
select post_likes.user_id, post_likes.post_id, count(post_likes.post_id)
from post_likes, post
where post.post_id=post_likes.post_id
group by post_likes.post_id
order by count(post_likes.post_id) desc;

-- 6. Average post per user
SELECT ROUND((COUNT(post_id) / COUNT(DISTINCT user_id) ),2) AS 'Average Post per User' 
FROM post;

-- 7. no. of login by per user
SELECT user_id, email, username, login.login_id AS login_number
FROM users 
natural join login;

-- 8. User who liked every single post (CHECK FOR BOT)
SELECT username, Count(*) AS num_likes 
FROM users 
INNER JOIN post_likes ON users.user_id = post_likes.user_id 
GROUP  BY post_likes.user_id 
HAVING num_likes = (SELECT Count(*) FROM   post); 

-- 9. User Never Comment
select user_id, username as 'User never comment'
from users
where user_id not in (select user_id from comments);

-- 10. User who commented on every post (CHECK FOR BOT)
SELECT username, Count(*) AS num_comment 
FROM users 
INNER JOIN comments ON users.user_id = comments.user_id 
GROUP  BY comments.user_id 
HAVING num_comment = (SELECT Count(*) FROM comments);

-- 11. User Not Followed by anyone
select user_id, username as 'User not followed by anyone'
from users
where user_id not in (select followee_id from follows);

-- 12. User Not Following Anyone
SELECT user_id, username AS 'User Not Following Anyone'
FROM users
WHERE user_id NOT IN (SELECT follower_id FROM follows);

-- 13. Posted more than 5 times
select user_id, count(user_id) as post_count from post
group by user_id
having post_count>5
order by count(user_id) desc;

-- 14. Followers > 40
select followee_id, count(follower_id) as follower_count from follows
group by followee_id
having follower_count>40
order by count(follower_id) desc;

-- 15. Any specific word in comment
select * from comments
where comment_text regexp'good|beautiful';

-- 16. Longest captions in post
select user_id, caption, length(post.caption) as caption_length from post
order by caption_length desc limit 5;