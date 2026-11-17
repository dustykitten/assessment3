A Signal's Journey: standalone website

Files
  index.html         the website
  img/               the pictures (keep this folder next to index.html)
  config.js          your Supabase address and key (step 3)
  supabase_setup.sql the database setup (step 2)

Step 1. Make a free database
  Go to supabase.com, sign up, and create a new project (any name, any region).

Step 2. Set it up
  Open supabase_setup.sql in a text editor. Replace CHANGE_ME with the teacher password you want.
  In Supabase, open SQL Editor, choose New query, paste the whole file, and press Run.
  Your teacher id is lwarden. You can change that name in the file too.

Step 3. Connect the site
  In Supabase go to Project Settings, then API. Copy the Project URL and the anon public key.
  Paste them into config.js between the quotation marks. Save.

Step 4. Put the site online
  Easiest: go to app.netlify.com/drop and drag the whole folder in. You get a link right away.
  Or: upload the folder to GitHub and turn on GitHub Pages, or to any web host or school server.

Step 5. Test it
  Open the link, type a name, write something in Question 1, wait a few seconds,
  then click Student answers, log in as lwarden with your password, and check the name appears.

Notes
  Your password is checked on the database, not stored in the page.
  The anon key is meant to be public. The database only lets the page save answers
  and only lets the teacher login read them.
  If config.js is empty, the site still works but answers stay in each student's browser.
