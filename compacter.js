// cmdOpts = db.adminCommand("getCmdLineOpts");
databases = db.adminCommand('listDatabases');

var  = db.getSiblingDB('test_compact_keeps_indexes_drop').testcoll;

// f-ce pro kompaktaci kolekci
//	over ze sme na secondary
//		pokud je force, tak neres
//
//	vybecDB nebo listALLdbs
//		vynechaj admin, config a local ak neni force
//
//		pro kazdou DB list colls
//			pro kazdou coll spusti compact s MSGo
//
//
//
function checkReplication(force=false) {
	rs.secondaryOk();
	return Boolean( force ? force : rs.status().ok);
}


function listAllDBs(force=false) {
	rs.secondaryOk();
	var cmd = { listDatabases: 1, nameOnly: true}
	if (!force) {
		cmd.filter = { name: /^((?!admin|config|local).)*$/ }
	}
	return db.adminCommand(cmd);
}

async function getDBs(dbName, force=false) {
	var databases;
	if (typeof dbName !== 'undefined') {
		databases = listAllDBs(force);
	} else {
		databases.push(dbName);
	}

	return new Promise((resolve, reject) => {
		function toArrayCallback(err, documents) {
			if (!err) {
				resolve(documents);
			} else {
				reject(err)
			}
		}
	})
}

function listColls(dbName) {
	rs.secondaryOk();
	return db.getSiblingDB(dbName).getCollectionNames();
}

async function dbcompact(dbName, force) {
	var databases = await getDBs(dbName, force);
	databases.forEach((database) => {
	    		printjson(databases[i]);
	    		print(databases[i]);
	    		// db.runCommand({compact: databases[i], comment: "Compacting collection "+database[i]});
	})
}


