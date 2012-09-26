#!/usr/local/bin/perl

use strict;
use Date::Format;

print <<THEEND
set xlabel "Date-Time"
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
THEEND
;

my $where;
my $from_xrange;
my $to_xrange;
my $xtics;
my $xformat;
my $every;

############
## user configuration section
############
my $tailed = ".tmp"; # extension of log tails
my @hosts = ('students01.u.washington.edu', 'students02.u.washington.edu', 'students03.u.washington.edu', 'vergil', 'depts01.u.washington.edu', 'depts02.u.washington.edu', 'depts03.u.washington.edu', 'ovid', 'courses01.u.washington.edu', 'courses02.u.washington.edu', 'vieyra11.myuw.net', 'vieyra12.myuw.net', 'socrates'); 

my $students_bkgnd = "xffffff";
my $depts_bkgnd = "xffffff";
my $courses_bkgnd = "xffffff";
my $vieyra_bkgnd = "xffffff";

# settings for last 24 hours graph
if (@ARGV[0] eq "last24h")
{
  # generate log.$host.tmp files with tail
  my $lognum =  24 * 60 / 5;
  foreach my $host (@hosts) {
    #debugging output
    #print "tail -n $lognum log.$host > log.$host$tailed\n";
    `tail -n $lognum log.$host > log.$host$tailed`;
  }

  my $now = time;
  $from_xrange = '"' . &time2str("%Y-%m-%d %H:%M:%S", $now-60*60*24) . '"';
  $to_xrange = '"' . &time2str("%Y-%m-%d %H:%M:%S", $now) . '"';
  $where = "img_last24h";
  $xtics = 60*60*2;
  $xformat = "%Hh";
  $every = 1;
}

# settings for last week graph
elsif (@ARGV[0] eq "lastweek")
{
  # generate log.$host.tmp files with tail
  my $lognum =  7 * 24 * 60 / 5;
  foreach my $host (@hosts) {
    #debugging output
    #print "tail -n $lognum log.$host > log.$host$tailed\n";
    `tail -n $lognum log.$host > log.$host$tailed`;
  }

  my $now = time;
  $from_xrange = '"' . &time2str("%Y-%m-%d %H:%M:%S", $now-60*60*24*7) . '"';
  $to_xrange = '"' . &time2str("%Y-%m-%d %H:%M:%S", $now) . '"';
  $where = "img_lastweek";
  $xtics = 60*60*24;
  $xformat = "%A\\n%b %d";
  $every = 5;
}

# settings for last 30 days graph
elsif (@ARGV[0] eq "last30d")
{
  # trim logs to last 30 days.  append old data to files in oldlogs/
  my $lognum = 30 * 24 * 60 / 5;
  my $curlines;
  my $old;
  foreach my $host (@hosts) {
    $curlines = `wc log.$host`;
    $curlines =~ /(\d+)/; 
    $curlines = $1;
    $old = $curlines-$lognum;
    if($old > 0) {
      `head -n $old log.$host >> oldlogs/log.$host`;
    }
    `tail -n $lognum log.$host > log.$host$tailed`;
    `mv log.$host$tailed log.$host`;
  }

  # set $tailed to null string
  $tailed = '';

  my $now = time;
  $from_xrange = '"' . &time2str("%Y-%m-%d %H:%M:%S", $now-60*60*24*30) . '"';
  $to_xrange = '"' . &time2str("%Y-%m-%d %H:%M:%S", $now) . '"';
  $where = "img_last30d";
  $xtics = 60*60*24*6;
  $xformat = "%m/%d\\n%Y";
  $every = 1;

}

# graph loads
print <<THEEND
set xtics $xtics
set xrange [ $from_xrange : $to_xrange ]
set format x "$xformat"

set terminal png small  picsize 480 240 $students_bkgnd 

set output "$where/load-students.png"
set title "Students Load"
set ylabel "Load (5 minute average)"
plot "log.students01.u.washington.edu$tailed" every $every using 2:5 title 'students01' with lines 1, \\
     "log.students02.u.washington.edu$tailed" every $every using 2:5 title 'students02' with lines 2, \\
     "log.students03.u.washington.edu$tailed" every $every using 2:5 title 'students03' with lines 3;

pause 1

set output "$where/load-vergil.png"
set title "Vergil Load"
plot "log.vergil$tailed" every $every using 2:6 title 'vergil' with lines 1;

pause 1

set terminal png small  picsize 480 240 $depts_bkgnd 

set output "$where/load-depts.png"
set title "Depts Load"
set ylabel "Load (5 minute average)"
plot "log.depts01.u.washington.edu$tailed" every $every using 2:5 title 'depts01' with lines 1, \\
     "log.depts02.u.washington.edu$tailed" every $every using 2:5 title 'depts02' with lines 2, \\
     "log.depts03.u.washington.edu$tailed" every $every using 2:5 title 'depts03' with lines 3;

pause 1

set terminal png small  picsize 480 240 $courses_bkgnd 

set output "$where/load-courses.png"
set title "Courses Load"
set ylabel "Load (5 minute average)"
plot "log.courses01.u.washington.edu$tailed" every $every using 2:5 title 'courses01' with lines 1, \\
     "log.courses02.u.washington.edu$tailed" every $every using 2:5 title 'courses02' with lines 2;

pause 1

set output "$where/load-ovid.png"
set title "Ovid Load"
plot "log.ovid$tailed" every $every using 2:6 title 'ovid' with lines 1;

# pause 1
# 
# set terminal png small  picsize 480 240 $vieyra_bkgnd
# 
# set output "$where/load-vieyra.png"
# set title "Vieyra Load"
# set ylabel "Load (5 minute average)"
# plot "log.vieyra11.myuw.net$tailed" every $every using 2:5 title 'vieyra11' with lines 1, \\
#      "log.vieyra12.myuw.net$tailed" every $every using 2:5 title 'vieyra12' with lines 2;
# 
# pause 1
# 
# set output "$where/load-socrates.png"
# set title "Socrates Load"
# plot "log.socrates$tailed" every $every using 2:6 title 'socrates' with lines 1;
# 
THEEND
;

# graph students responses
print <<THEEND
set terminal png small  picsize 480 240 $students_bkgnd
set yrange [-1:300]
THEEND
;

foreach my $host ("students01.u.washington.edu", "students02.u.washington.edu", "students03.u.washington.edu")
{
  print <<THEEND
set output "$where/response-$host.png"
set title "$host response"
set ylabel "Response Time (ms)"
plot "log.$host$tailed" every $every using 2:7 title 'Min' with lines 3, \\
     "log.$host$tailed" every $every using 2:11 title 'Max' with lines 3, \\
     "log.$host$tailed" every $every using 2:9 title 'Mean' with lines 1;

pause 1

THEEND
;
}

# graph depts responses
print <<THEEND
set terminal png small  picsize 480 240 $depts_bkgnd
#set yrange [-1:1500]
THEEND
;

foreach my $host ("depts01.u.washington.edu", "depts02.u.washington.edu", "depts03.u.washington.edu")
{

  print <<THEEND
set output "$where/response-$host.png"
set title "$host response"
set ylabel "Response Time (ms)"
plot "log.$host$tailed" every $every using 2:7 title 'Min' with lines 3, \\
     "log.$host$tailed" every $every using 2:11 title 'Max' with lines 3, \\
     "log.$host$tailed" every $every using 2:9 title 'Mean' with lines 1;

pause 1

THEEND
;
}

# graph courses responses
print <<THEEND
set terminal png small  picsize 480 240 $courses_bkgnd
#set yrange [-1:1500]
THEEND
;

foreach my $host ("courses01.u.washington.edu", "courses02.u.washington.edu")
{

  print <<THEEND
set output "$where/response-$host.png"
set title "$host response"
set ylabel "Response Time (ms)"
plot "log.$host$tailed" every $every using 2:7 title 'Min' with lines 3, \\
     "log.$host$tailed" every $every using 2:11 title 'Max' with lines 3, \\
     "log.$host$tailed" every $every using 2:9 title 'Mean' with lines 1;

pause 1

THEEND
;
}

# graph vieyra responses
# print <<THEEND
# set terminal png small  picsize 480 240 $vieyra_bkgnd
# set yrange [-1:100]
# THEEND
# ;
# 
# foreach my $host ("vieyra11.myuw.net", "vieyra12.myuw.net")
# {
#   print <<THEEND
# set output "$where/response-$host.png"
# set title "$host response"
# set ylabel "Response Time (ms)"
# plot "log.$host$tailed" every $every using 2:7 title 'Min' with lines 3, \\
#      "log.$host$tailed" every $every using 2:11 title 'Max' with lines 3, \\
#      "log.$host$tailed" every $every using 2:9 title 'Mean' with lines 1;
# 
# pause 1
# 
# THEEND
# ;
# }
