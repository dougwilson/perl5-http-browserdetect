use HTTP::BrowserDetect;
use Mojolicious::Lite;

get '/' => sub {
	my ($self) = @_;
	my $ua = $self->req->headers->user_agent;
	my $browser = HTTP::BrowserDetect->new($ua);

	# Various stash items
	$self->stash(browser => $browser);

	$self->render('index');
};

helper bd => sub {
	my ($self, $attr) = @_;

	# Get the value
	my $value = $self->stash('browser')->$attr;

	return defined $value ? $value : 'undef';
};

app->secret('HTTP::BrowserDetect');

# Start the Mojolicious command system
app->start;

__DATA__

@@ index.html.ep
<!DOCTYPE html>
<html>

<head>
<title>HTTP::BrowserDetect results</title>
%= stylesheet '/global.css'
</head>

<body>
<h1><code>HTTP::BrowserDetect</code> Results for Request</h1>

<h2>Request User Agent String</h2>
<p><code><%= bd 'user_agent' %></code></p>

<h2>Browser</h2>
<p>
<code><%= bd 'browser_string' %></code>
version <code><%= bd 'public_version' %></code>
(major <code><%= bd 'public_major' %></code> minor <code><%= bd 'public_minor' %></code>)
running on <code><%= bd 'os_string' %></code> (device <code><%= bd 'device_name' %></code>).
Language <code><%= bd 'language' %></code>, country <code><%= bd 'country' %></code>.
</p>

<h2>Rendering Engine</h2>
<p>
<code><%= bd 'engine_string' %></code>
version <code><%= bd 'engine_version' %></code>
(major <code><%= bd 'engine_major' %></code> minor <code><%= bd 'engine_minor' %></code>).
</p>

<h2>Browser Properties</h2>
<p>Wall-of-properties shows red when property is <code>false</code>, green when <code>true</code>.</p>
<div class="prop-container">
% foreach my $prop (sort @HTTP::BrowserDetect::ALL_TESTS) {
<code class="prop <%= $browser->$prop ? 'prop-true' : 'prop-false' %>"><%= $prop %></code>
% }
</div>
<p><code>browser_properties</code> returns <code><%= dumper [sort $browser->browser_properties] %></code></p>
</body>

</html>

@@ global.css
body {font-family: Calibri, serif}
code {font-family: Consolas, "Lucida Console", "Courier New", Courier, monospace}
p code {background-color: lightcyan}
code.prop {display: inline-block; padding: 0.2em; margin: 0.1em}
code.prop-false {background-color: red; color: white}
code.prop-true {background-color: green; color: white}
.prop-container {text-align: justify}
