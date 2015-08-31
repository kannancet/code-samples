# DHH score challenge


	David Heinemeier Hansson's github url is https://github.com/dhh .

	Github provides information about his public commits in JSON format at https://api.github.com/users/dhh/events/public .

	In the JSON data there is an attribute called "type" which denotes what kind of commit it was.

	Let's say that we give following score to DHH based on the "type" of the commit

	IssuesEvent = 7
	IssueCommentEvent = 6
	PushEvent = 5
	PullRequestReviewCommentEvent = 4
	WatchEvent = 3
	CreateEvent = 2
	Any other event = 1
	Task

	Write a ruby program which when executed prints the score of https://github.com/dhh . The answer printed on the terminal should be like this.

	Calculate the score based on the item results returned only from first page of that API call. Do not worry about pagination.

	$ ruby exercise.rb
	DHH's github score is xxx
	What we are looking for

	https://gist.github.com/neerajdotname/b369449b85e6a634b12b


## Solution - How to run the program ?
	
	git clone https://github.com/bigbinary/challenges-for-kannan.git
	cd challenges-for-kannan
	ruby lib/dhh_score.rb
	 

## Test - How to test the program ?
	
	git clone https://github.com/bigbinary/challenges-for-kannan.git
	cd challenges-for-kannan
	rspec
	  
