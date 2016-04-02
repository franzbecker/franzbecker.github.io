---
layout: post
title: "Defining a simple bash function for Gradle"
tags: ["gradle", "bash"]
---

When using Gradle (or Maven) in your project it is convenient to define bash aliases or functions for reoccurring tasks. For Maven this is pretty straightforward, simply put something like

```bash
alias b='mvn clean install'
```

in your bash profile (`~/.profile`) and you can simply enter `b` in your console instead of typing `mvn clean install` over and over again.

With Gradle the story is a bit different as you're supposed to use the Gradle [wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html). Using the Gradle wrapper makes sure everyone on the team (including your CI server) uses the same version of Gradle for building your software and frees your team members from manually installing Gradle.

So the first attempt would be to do something like this:

```bash
alias g='./gradlew $@'
alias b='g build'
```

This is ok for most situations and lets you type `b` or `g build` instead of `./gradlew build` in your console.
However, there are situations where you cannot use the Gradle wrapper -- for example when initializing a new project.
If you want to keep using your awesome new alias in these cases you need a small bash function that checks if the current directory contains a file named `gradlew` and if not calls `gradle` as a fall-back.

```bash
# Call ./gradlew or gradle as fall-back
function g() {
	if [ -f gradlew ]; then
		./gradlew $@
	else
		# if there is no ./gradlew check if there is a build.gradle file
		# if not ask the user for confirmation (avoid creation of .gradle dir in unrelated directories)
		if [ -f build.gradle ]; then
			gradle $@
		else		
			read -n1 -p "There is no build.gradle in this directory. Do you want to continue? [y,n]" doit
			echo ""
			case $doit in  
				y|Y) gradle $@ ;;
			esac
		fi
	fi
}
```
Note that I built in a confirmation in case there is no `build.gradle` in the current directory since I ended up having `.gradle` directories everywhere ;-)

## Installation

If you want to use this script here's an example setup:

```bash
mkdir -p ~/.bash \
&& curl -L -s https://git.io/vVfXi > ~/.bash/gradle.bash \
&& echo "source ~/.bash/gradle.bash" >> ~/.profile \
&& cat ~/.bash/gradle.bash # verify the downloaded script

source ~/.profile # reload profile for current bash
```


## Alternatives
There are quite few scripts out there, also with auto completion. I like the one from Nolan Lawson, which can be found here: [https://git.io/vV8sj](https://git.io/vV8sj). On my Mac it worked fine after installing `md5sum` (`brew install md5sha1sum`).

Simply add `complete -F _gradle g` to the end of it and it works nicely with the `g()` function from above.

Let me know what you think!
