/* global module:false */
module.exports = function (grunt) {
  // Project configuration
  grunt.initConfig({
    "clean": {
      "tmp": ["tmp2/"],
      "web": ["web2/"]
    },
    "copy": {
      "core": {
        "files": [{
          "cwd": "src/",
          "dest": "tmp2/",
          "expand": true,
          "src": ["**"]
        }],
        "options": {
          "noprocess": ["**/*.ico", "**/*.png"],
          process(content, srcpath) {
            let result = content.replace(/_MmCOPYRIGHT_/g, "2008-2017");
            result = result.replace(/_MmBUILDDATE_/g, grunt.template.date(new Date(), "ddd mmm dd yyyy HH:MM TT Z"));
            return result.replace(/_MmVERSION_/g, grunt.config("pkg.version"));
          }
        }
      },
      "desktop": {
        "files": {
          "web2/desktop/index.html": ["tmp2/index.html"],
          "web2/desktop/js/paste.js": ["tmp2/js/paste.js"],
          "web2/desktop/pastelet-history.txt": ["tmp2/pastelet-history.txt"]
        }
      },
      "email": {
        "files": {"web2/email.html": ["tmp2/email.html"]},
        "options": {
          process(content, srcpath) {
            const result = content.replace(/_MmSPECIAL_/g, "Email/Login");
            return result.replace(/special_Pastelet/g, "Email/Login Pastelet");
          }
        }
      },
      "images": {
        "files": [{
          "cwd": "tmp2/img",
          "dest": "web2/img/",
          "expand": true,
          "src": ["*"]
        }]
      },
      "manifests": {
        "files": {
          "web2/___.manifest": ["tmp2/pastelet.manifest"],
          "web2/email.manifest": ["tmp2/pastelet.manifest"],
          "web2/tel.manifest": ["tmp2/pastelet.manifest"]
        }
      },
      "options": {
        "mode": true,
        "noProcess": ["**/*.{png,gif,jpg,ico,ttf,otf,woff,svg}"],
        "nonull": true,
        "timestamp": true
      },
      "pastelet": {
        "files": {"web2/___.html": ["tmp2/pastelet.html"]},
        "options": {
          process(content, srcpath) {
            const result = content.replace("pastelet.manifest", "___.manifest");
            return result.replace(/("canonical" href="http:\/\/mmind\.me\/)pastelet/g, "$1___");
          }
        }
      },
      "tel": {
        "files": {"web2/tel.html": ["tmp2/email.html"]},
        "options": {
          process(content, srcpath) {
            let result = content.replace(/_MmSPECIAL_/g, "Telephone Number");
            result = result.replace(/special_Pastelet/g, "Telephone Number Pastelet");
            result = result.replace(/type="email/g, 'type="tel');
            result = result.replace(/email@abc.com/g, "8005551212");
            return result.replace(/("canonical" href="http:\/\/mmind\.me\/)email/g, "$1tel");
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
      "target": {"files": {"web2/desktop/css/mm.css": ["tmp2/mm.css"]}}
    },
    "eslint": {
      "options": {"configFile": ".eslintrc.yml"},
      "target": ["Gruntfile.js", "src/js/*.js"]
    },
    "html_minify": {
      "options": {},
      "target": {
        "files": {
          "web2/___.html": ["web2/___.html"],
          "web2/desktop/index.html": ["web2/desktop/index.html"],
          "web2/email.html": ["web2/email.html"],
          "web2/tel.html": ["web2/tel.html"]
        }
      }
    },
    "minifyHtml": {
      "options": {},
      "target": {
        "files": {
          "web2/___.html": ["web2/___.html"],
          "web2/desktop/index.html": ["web2/desktop/index.html"],
          "web2/email.html": ["web2/email.html"],
          "web2/tel.html": ["web2/tel.html"]
        }
      }
    },
    "pkg": grunt.file.readJSON("package.json"),
    "rename": {
      "main": {
        "files": {
          "web2/___": ["web2/___.deflate"],
          "web2/email": ["web2/email.deflate"],
          "web2/tel": ["web2/tel.deflate"]
        }
      },
      "options": {"force": true}
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
          "semicolons": true,
          "space_colon": false
        },
        "compress": {
          "booleans": true,
          "cascade": true,
          "collapse_vars": false,
          "comparisons": true,
          "conditionals": true,
          "dead_code": false,
          "drop_console": false,
          "drop_debugger": true,
          "evaluate": true,
          "expression": false,
          "global_defs": {},
          "hoist_funs": false,
          "hoist_vars": false,
          "if_return": true,
          "join_vars": false,
          "keep_fargs": true,
          "loops": true,
          "negate_iife": true,
          "passes": 1,
          "properties": true,
          "pure_funcs": [],
          "pure_getters": true,
          "reduce_vars": false,
          "sequences": true,
          "side_effects": false,
          "top_retain": [],
          "toplevel": true,
          "unsafe": true,
          "unsafe_comps": true,
          "unsafe_math": true,
          "unsafe_proto": true,
          "unused": false,
          "warnings": true
        },
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
          "semicolons": true,
          "space_colon": false
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
          "cwd": "tmp2/js",
          "dest": "web2/js",
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
        "blocksplitting": true,
        "blocksplittinglast": false,
        "blocksplittingmax": 15,
        "mode": "deflate",
        "numiterations": 96,
        "verbose": false,
        "verbose_more": false
      },
      "target": {
        "files": {
          "web2/___.deflate": ["web2/___.html"],
          "web2/email.deflate": ["web2/email.html"],
          "web2/tel.deflate": ["web2/tel.html"]
        }
      }
    }
  });

  // Load plugins
  grunt.loadNpmTasks("grunt-contrib-clean");
  grunt.loadNpmTasks("grunt-contrib-copy");
  grunt.loadNpmTasks("grunt-contrib-csslint");
  grunt.loadNpmTasks("grunt-contrib-cssmin");
  grunt.loadNpmTasks("grunt-contrib-uglify");
  grunt.loadNpmTasks("grunt-contrib-rename");
  grunt.loadNpmTasks("grunt-eslint");
  grunt.loadNpmTasks("grunt-html-minify");
  grunt.loadNpmTasks("grunt-minify-html");
  grunt.loadNpmTasks("grunt-yamllint");
  grunt.loadNpmTasks("grunt-zopfli-native");

  grunt.log.writeln(`\n${grunt.config("pkg.name")} ${grunt.config("pkg.version")}`);

  // preflight task
  grunt.registerTask("preflight", ["yamllint", "eslint", "csslint"]);

  // copytransform task
  grunt.registerTask("copytransform", ["copy:core", "copy:desktop", "cssmin",
    "copy:email", "copy:images", "copy:manifests", "copy:pastelet",
    "copy:tel", "uglify"]);

  // compresshtml task
  grunt.registerTask("compresshtml", ["preflight", "copytransform",
    "html_minify", "minifyHtml", "zopfli", "rename"]);


  grunt.registerTask("test", ["preflight", "copytransform", "compresshtml"]);
  // "html_minify", "minifyHtml", "zopfli", "rename"]);

  // Default task
  grunt.registerTask("default", ["clean", "test"]);

};
