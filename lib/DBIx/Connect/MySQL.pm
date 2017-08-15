package DBIx::Connect::MySQL;

# DATE
# VERSION

use strict;
use warnings;
use DBI;

sub connect {
    my $pkg  = shift;
    my $dsn  = shift;
    my $user = shift;
    my $pass = shift;

  GET_USER_PASS_FROM_MY_CNF:
    {
        last if defined $user && defined $pass;
        if (-f (my $path = "$ENV{HOME}/.my.cnf")) {
            open my $fh, "<", $path or last;
            while (<$fh>) {
                if (!defined($user) && /^\s*user\s*=\s*(.+)/) {
                    $user = $1;
                }
                if (!defined($user) && /^\s*password\s*=\s*(.+)/) {
                    $pass = $1;
                }

                last if defined $user && defined $pass;
            }
        }
    }

    DBI->connect($dsn, $user, $pass, @_);
}

1;
# ABSTRACT: Connect to DBI (mysql), search user/password from .my.cnf

=head1 SYNOPSIS

Instead of:

 use DBI;
 my $dbh = DBI->connect("dbi:mysql:database=mydb", "someuser", "somepass");

you can now do:

 use DBIx::Connect::MySQL;
 my $dbh = DBIx::Connect::MySQL->connect("dbi:mysql:database=mydb", undef, undef);

and user/password will be searched in F<~/.my.cnf> if unset.


=head1 DESCRIPTION

This is a small wrapper for C<< DBI->connect >> because the client library does
not automatically search for user/password from F<.my.cnf> files like in
PostgresSQL.
