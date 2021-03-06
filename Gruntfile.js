module.exports = function (grunt) {
  "use strict";
  // Project configuration
  grunt.initConfig({
    "clean": {
      "tmp": ["tmp/"],
      "web": ["web/"],
      "web-html": ["web/*.html"]
    },
    "copy": {
      "core": {
        "files": [{
          "cwd": "src/",
          "dest": "tmp/",
          "expand": true,
          "src": ["**"]
        }],
        "options": {
          "noprocess": ["**/*.ico", "**/*.png"],
          process(content, srcpath) {
            let result = content.replace(/_MmCOPYRIGHT_/g, "2008-2018");
            result = result.replace(/_MmBUILDDATE_/g, grunt.template.date(new Date(), "ddd mmm dd yyyy HH:MM TT Z"));
            return result.replace(/_MmVERSION_/g, grunt.config("pkg.version"));
          }
        }
      },
      "desktop": {
        "files": {
          "web/desktop/index.html": ["tmp/index.html"],
          "web/desktop/js/paste.js": ["tmp/js/paste.js"],
          "web/desktop/pastelet-history.txt": ["tmp/pastelet-history.txt"]
        }
      },
      "email": {
        "files": {
          "web/email.html": ["tmp/email.html"],
          "web/email.url.html": ["tmp/email.url.html"]
        },
        "options": {
          process(content, srcpath) {
            const result = content.replace(/_MmSPECIAL_/g, "Email/Login");
            return result.replace(/special_Pastelet/g, "Email/Login Pastelet");
          }
        }
      },
      "images": {
        "files": [{
          "cwd": "tmp/img",
          "dest": "web/img/",
          "expand": true,
          "src": ["*"]
        }]
      },
      "manifests": {
        "files": {
          "web/___.manifest": ["tmp/pastelet.manifest"],
          "web/email.manifest": ["tmp/pastelet.manifest"],
          "web/tel.manifest": ["tmp/pastelet.manifest"]
        }
      },
      "options": {
        "mode": true,
        "noProcess": ["**/*.{deflate,png,gif,gz,jpg,ico,ttf,otf,woff,svg}"],
        "nonull": true,
        "timestamp": true
      },
      "pastelet": {
        "files": {"web/___.html": ["tmp/pastelet.html"]},
        "options": {
          process(content, srcpath) {
            const result = content.replace("pastelet.manifest", "___.manifest");
            return result.replace(/("canonical" href="http:\/\/mmind\.me\/)pastelet/g, "$1___");
          }
        }
      },
      "tel": {
        "files": {
          "web/tel.html": ["tmp/email.html"],
          "web/tel.url.html": ["tmp/tel.url.html"]
        },
        "options": {
          process(content, srcpath) {
            let result = content.replace(/_MmSPECIAL_/g, "Telephone Number");
            result = result.replace(/special_Pastelet/g, "Telephone Number Pastelet");
            result = result.replace(/type="email/g, 'type="tel');
            result = result.replace(/("canonical" href="http:\/\/mmind\.me\/)email/g, "$1tel");
            result = result.replace(/email@abc.com/g, "8005551212");
            return result.replace(/js\/email.js/g, "js/tel.js");
          }
        }
      }
    },
    "csslint": {
      "files": ["src/mm.css"],
      "options": {
        "box-model": false,
        "font-sizes": false,
        "ids": false
      }
    },
    "cssmin": {
      "options": {
        "debug": false,
        "keepSpecialComments": 0,
        "rebase": false,
        "report": "min"
      },
      "target": {"files": {"web/desktop/css/mm.css": ["tmp/mm.css"]}}
    },
    "eslint": {
      "options": {"configFile": ".eslintrc.yml"},
      "target": ["Gruntfile.js", "src/js/*.js"]
    },
    "html_minify": {
      "target": {
        "files": {
          "web/___.html": ["web/___.html"],
          "web/desktop/index.html": ["web/desktop/index.html"],
          "web/email.html": ["web/email.html"],
          "web/email.url.html": ["web/email.url.html"],
          "web/tel.html": ["web/tel.html"],
          "web/tel.url.html": ["web/tel.url.html"]
        }
      }
    },
    "minifyHtml": {
      "target": {
        "files": {
          "web/___.html": ["web/___.html"],
          "web/desktop/index.html": ["web/desktop/index.html"],
          "web/email.html": ["web/email.html"],
          "web/email.url.html": ["web/email.url.html"],
          "web/tel.html": ["web/tel.html"],
          "web/tel.url.html": ["web/tel.url.html"]
        }
      }
    },
    "pkg": grunt.file.readJSON("package.json"),
    "rename": {
      "main": {
        "files": {
          "web/___": ["web/___.deflate"],
          "web/desktop/css/mm.css": ["web/desktop/css/mm.deflate"],
          "web/desktop/index.html": ["web/desktop/index.deflate"],
          "web/email": ["web/email.deflate"],
          "web/tel": ["web/tel.deflate"]
        }
      },
      "options": {"force": true}
    },
    "text2datauri": {
      "options": {
        "encoding": "base64",
        "mimeType": "text/html",
        "protocol": "data:",
        "sourceCharset": "utf-8",
        "targetCharset": "utf-8"
      },
      "web/email.url": "web/email.url.html",
      "web/tel.url": "web/tel.url.html"
    },
    "uglify": {
      "options": {
        "beautify": false,
        "codegen": {
          "bracketize": false,
          "comments": false,
          "ie_proof": false,
          "indent_level": 0,
          "max_line_len": 32766,
          "quote_keys": false,
          "quote_style": 1,
          "semicolons": true
        },
        "compress": {
          "collapse_vars": false,
          "expression": true,
          "passes": 2,
          "pure_funcs": [],
          "pure_getters": true,
          "reduce_vars": false,
          "side_effects": false,
          "toplevel": true,
          "unsafe": true,
          "unsafe_comps": true,
          "unsafe_math": true,
          "unsafe_proto": true,
          "unused": false
        },
        "es": 6,
        "ie8": false,
        "mangle": {"toplevel": false},
        "maxLineLen": 32766,
        "output": {
          "ascii_only": true,
          "bracketize": false,
          "comments": false,
          "indent_level": 0,
          "max_line_len": 32766,
          "quote_keys": false,
          "quote_style": 0,
          "semicolons": true
        },
        "preserveComments": false,
        "properties": false,
        "quoteStyle": 1,
        "report": "min",
        "stats": true,
        "wrap": false
      },
      "target": {
        "files": [{
          "cwd": "tmp/js",
          "dest": "web/js",
          "expand": true,
          "src": "*.js"
        }]
      }
    },
    "yamllint": {
      "files": {"src": [".*.yml", "*.yml", "*.yaml"]},
      "options": {"schema": "FAILSAFE_SCHEMA"}
    },
    "zopfli": {
      "options": {
        "format": "deflate",
        "iterations": 96,
        "report": true
      },
      "target": {
        "files": {
          "web/___.deflate": ["web/___.html"],
          "web/desktop/css/mm.deflate": ["web/desktop/css/mm.css"],
          "web/desktop/index.deflate": ["web/desktop/index.html"],
          "web/email.deflate": ["web/email.html"],
          "web/tel.deflate": ["web/tel.html"]
        }
      }
    }
  });

  // Load plugins
  grunt.loadNpmTasks("grunt-contrib-clean");
  grunt.loadNpmTasks("grunt-contrib-copy");
  grunt.loadNpmTasks("grunt-contrib-csslint");
  grunt.loadNpmTasks("grunt-contrib-cssmin");
  grunt.loadNpmTasks("grunt-contrib-rename");
  grunt.loadNpmTasks("grunt-contrib-uglify");
  grunt.loadNpmTasks("grunt-eslint");
  grunt.loadNpmTasks("grunt-html-minify");
  grunt.loadNpmTasks("grunt-minify-html");
  grunt.loadNpmTasks("grunt-yamllint");
  grunt.loadNpmTasks("grunt-zopfli");
  grunt.loadNpmTasks("text2datauri");

  grunt.log.writeln(`\n${grunt.config("pkg.name")} ${grunt.config("pkg.version")}`);

  // preflight task
  grunt.registerTask("preflight", ["yamllint", "eslint", "csslint"]);

  // copytransform task
  grunt.registerTask("copytransform", ["copy:core", "copy:desktop", "cssmin",
    "copy:email", "copy:images", "copy:manifests", "copy:pastelet",
    "copy:tel", "uglify"]);

  // compresshtml task
  grunt.registerTask("compresshtml", ["preflight", "copytransform",
    "html_minify", "minifyHtml", "text2datauri", "zopfli", "rename"]);

  // test task
  grunt.registerTask("test", ["preflight", "copytransform", "compresshtml"]);

  // Default task
  grunt.registerTask("default", ["clean", "test", "clean:web-html",
    "clean:tmp"]);

};
