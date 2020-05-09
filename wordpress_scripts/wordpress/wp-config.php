<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'lgxzj-wordpress' );

/** MySQL database password */
define( 'DB_PASSWORD', 'password-wordpress' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost:/lgxzj-install/mysql/data/mysql.sock' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'O-A3}^GuA@]sGF(lyN.jpQ2u{d[Q;Tc@i*W+iD~z$7.bFlQc]MDXn~f46?`+)uQn' );
define( 'SECURE_AUTH_KEY',  'DZt4O8p]I&fyfZb4fo.?-1,HS~f+)0u]%wLwLWRq3Y@19P_Kgih6pM-}_;:4elfF' );
define( 'LOGGED_IN_KEY',    'c>.i?<y-v%MPgO/60TRMis4+{ |h1{/ldaS+JPu5M>xp+fWIj_P`XOPm1#VaZUi:' );
define( 'NONCE_KEY',        '&F!bm1>x.58,L|e*l:32|v_8-Nso07/N#CK-naK#|;$G6CWUs-8Y_OvJRx h7B*H' );
define( 'AUTH_SALT',        '8evX eD4W+DrZEY2Qj4@.XJQvSA_Mh6?h=n>,Bw{$-uUC_r+]Ve1+-#Yx.]1?H/i' );
define( 'SECURE_AUTH_SALT', 'ahU=vJ~G5e$&Ei#X|4Rqii8/buEPjug(}8>2oK+2H=9F~7%+)lT!8G2lk+U/Knf{' );
define( 'LOGGED_IN_SALT',   ' ]6(y+cz.M:OF>7=<q4CI3wgzvv}tv?- |J,j:r1xb*k7i;H?v+3rzwI7ygiXt3q' );
define( 'NONCE_SALT',       '+` [SQHJsV(8tZeAg-+{U3hNoH@R0C`l>6Rmq!?w?1iO>&w=M:?v-==Co=oEU4>|' );

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', true );
define('WP_DEBUG_LOG', true);

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
