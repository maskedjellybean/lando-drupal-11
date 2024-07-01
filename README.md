# Lando config for Drupal 11 plus useful tooling commands/scripts

# How to use

* Install Lando (https://docs.lando.dev/install/macos.html).
* Git clone this repo.
* Go to https://www.drupal.org/project/drupal/releases/11.x-dev and run the `composer create-project` command shown there to create a Drupal 11 project in a different directory.
* Copy `.lando.yml` and `./lando/` from this repo into the root of the Drupal 11 project directory.
* `cd` into the Drupal 11 project directory.
* Edit `./web/sites/default/settings.php`
  * Uncomment these lines:
  ```
  if (file_exists($app_root . '/' . $site_path . '/settings.local.php')) {
    include $app_root . '/' . $site_path . '/settings.local.php';
  }
  ```
* Run `lando start`.
* Assuming `lando start` completes successfully, visit one of the URLs given. Bypass the browser privacy warning (you'll have to do this every time after `lando start`).
* Follow the Drupal installation GUI. When asked for database credentials, enter:
  * Database name: drupal
  * Database username: drupal
  * Database password: drupal
* You should have a working Drupal site.
* Run `lando` to see all Lando tooling commands.
* Feel free to delete this repo that you cloned. From this point on, do all your work within the Drupal 11 project directory.
* We're using the Lando Drupal plugin and the `drupal11` recipe, so be sure to read the Lando docs (https://docs.lando.dev/plugins/drupal/tooling.html).

# If using as the basis of an actual project

After following the directions under "How to use", if you plan to use this as the basis of an actual project:
* Run `lando destroy -y && lando start`. Beware you will lose your current database.
* Find all instances of "drupal-11-dev" within `.lando.yml` and `./lando/` in the Drupal 11 project directory and replace with the name of your project.
* Run `lando start`.

## Configuration

Included is a `settings.local.php`, `php.ini` and `drush.ini` with reasonable settings. You can find them in `./lando/configs/`.
Feel free to modify them for your needs. After modifying, run `lando rebuild -y`.

# Non custom Lando tooling commands

These came along with the drupal11 recipe we used, but they're worth mentioning.

## lando composer
```
lando composer
```
Runs Composer commands.

# Slightly custom Lando tooling commands

These came along with the drupal11 recipe we used, but they're slightly customized.

## lando drush
```
lando drush
```
Runs Drush commands.

In order to use this, run `lando composer require drush/drush` first.

This customized command will run Drush without the memory limit configured for PHP in `./lando/configs/php/php.ini`.

# Custom Lando tooling commands

These are potentially useful tooling commands/scripts that are completely custom. Most of them will not be usable until you require the dependency via Composer.

Feel free to delete any that are not useful to you.

Run `lando` to see all commands.

## lando drupal-reinstall
```
lando drupal-reinstall
```
DROPs the current database, runs `composer install`, `drush site:install`, database updates, config import, deploy hooks and clears caches.

## lando drupal-reset
```
lando drupal-reset
```
KEEPs the current database, runs `composer install`, database updates, config import, deploy hooks and clears caches.

## lando drupal-create-users
```
lando drupal-create-users
```
Creates Drupal test users. You will need to modify `./lando/scripts/drupal-create-users.sh` for your project.

## lando logs-drupal
```
lando logs-drupal
```
Tails Drupal watchdog logs.

## lando logs-php
```
lando logs-php
```
Tails PHP error logs.

## PHPCS
```
lando php-cs
```
Runs PHPCS and PHPCBF.

You will need to configure and require PHPCS and dependencies first.

## Twig CS Fixer
```
lando twig-cs
```
Runs Twig CS Fixer.

You will need to run `lando composer require --dev vincentlanglet/twig-cs-fixer` first.

## Behat
```
lando behat
```
Runs Behat tests.

You will need to configure and require Behat and dependencies first.

## Xdebug
```
lando xdebug
```
Toggles Xdebug on/off. Optionally enables/disables caching by modifying `settings.local.php`. Disabling caching ensures breakpoints are triggered.

You will also need to configure your IDE.

# Lando, PhpStorm & Xdebug

## Enabling Xdebug

Run:
```
lando xdebug
```

## PhpStorm configuration
Before Xdebug will work you will need to configure PhpStorm. You should only need to do this once.

### Create a CLI Interpreter
* Go to PhpStorm settings > PHP.
* Set "PHP language level" to the PHP version you're running. (`lando php -v`)
* Click the three dots to the right of "CLI Interpreter".
* In the left page, click +. Choose "From Docker, Vagrant...".
* Select "Docker".
* From "Image name" choose something like "devwithlando/php:8.1-apache-4" (your options may vary).
* Click Ok.
* Change "Name" to whatever you like, but some indication that it is Lando related would be smart.
* Ensure "Visible only for this project" is checked.
* Change "Debugger extension" to something like "/usr/local/lib/php/extensions/no-debug-non-zts-20210902/xdebug.so".
  * To find the correct path, after running `lando start`, run `lando ssh`. Then run `ls /usr/local/lib/php/extensions`.
* Click Apply.
* Click the refresh button to the right of the "PHP executable" field.
* Underneath the field you should see the PHP and Xdebug versions appear.
* Click Ok.

### Configure Include Paths
* Go to PhpStorm settings > PHP.
* Under the "Include Path" tab, click +.
* Click "Specify Other...". Select any directory.
* Select the path you just created and replace it with something like "/Users/USER_NAME/.lando/config/drupal11", replacing "USER_NAME" with your username.
* Click Apply and Ok.

### Configure Debug settings
* Go to PhpStorm settings > PHP > Debug.
* Set "Max simultaneous connections" to 3.
* Set "Debug port" to 9003.
* Check "Break at first line in PHP scripts". You can uncheck this later once you've confirmed Xdebug is triggering breakpoints.
* Click Apply and Ok.

### Configure Server settings
* Go to PhpStorm settings > PHP > Servers.
* Click + to create a new server.
* Set "Name" to "appserver". This needs to correspond to the name of your Apache service as configured in `.lando.yml`.
* Set "Host" to "localhost".
* Check "Use path mappings...".
* Click on the path to the root of the project. Click the pencil icon. Enter "/app".
* Click on the path "/Users/USER_NAME/.lando/config/drupal11". Click the pencil icon. Enter "/srv/includes".
* Click Apply and Ok.

## Setting breakpoints
* With Xdebug enabled (`lando xdebug on`) and PhpStorm configured, set a breakpoint on a line that you expect to be run.
  * A good place to test would be the first line of `hook_preprocess_html`. This should be called on every page load.
* In the top right corner of PhpStorm, hit the "Start listening for PHP Debug connections" button (phone icon).
* In browser, load or refresh a page of the site.
* If in Phpstorm settings > PHP > Debug you enabled "Break at first line in PHP scripts", the first line of `index.php` should be triggered and the PhpStorm Debugger window should open.
* Click the "Resume program" button (play icon).
* The breakpoint you set should be triggered.
* If the breakpoint was triggered, go to Phpstorm settings > PHP > Debug and disable "Break at first line in PHP scripts".
* Congrats, you're now step debugging.
* Whenever you're done, click the "Stop listening for PHP Debug connections" button (phone icon). This will prevent Xdebug from listening to Drush and Composer commands.
* Optionally run `lando xdebug` or `lando xdebug off`.

### Troubleshooting breakpoints
If your breakpoints are not being triggered, there are a few things to try.
* Restart PhpStorm.
* Ensure that your breakpoint is on a line of code that will definitely be run when you load/refresh your site in browser.
* Check to make sure PhpStorm is listening on the port. If nothing is listening this will return nothing: `nc -z localhost 9003`. If something is listening you'll see "Connection to localhost ... succeeded".
* Run: `sudo lsof -i:9003` and verify that you only see PhpStorm.
* Verify that `lando/configs/php/php.ini` is being loaded by running: `lando php -i | grep "configs/php/php.ini"`.
* In case it might reveal something useful, you can view the Xdebug logs by running `lando logs-xdebug`.