
# Simple python3 script that grabs a template project and copies it N times (one per sample)
# while replacing strings in some specified files (see genFiles),
# eg. %%sampleName%% -> PbsMaterials
#
# And copies the media folder into each template (using symlinks to save disk space)

import os
import shutil

ogreBinariesPath = os.path.abspath( '../../../build/Android/' )
ogreSourcePath = os.path.abspath( '../../../' )

sampleNames = ['PbsMaterials']

templateFiles = list()
for (dirpath, dirnames, filenames) in os.walk( './Template' ):
    templateFiles += [os.path.join( dirpath, file ) for file in filenames]

genFiles = [ \
	'app/build.gradle',
	'app/CMakeLists.txt',
	'app/src/main/AndroidManifest.xml',
	'app/src/main/res/values/strings.xml',
]

mediaFolders = [ \
	'2.0',
	'Compute',
	'Hlms',
	'materials',
	'models',
	'packs',
	'VCT',
]

for sampleName in sampleNames:
	# Copy media folders into assets folder
	dstAssetsPath = './Autogen/' + sampleName + "/app/src/main/assets/"
	os.makedirs( os.path.dirname( dstAssetsPath ), exist_ok=True )
	for mediaFolder in mediaFolders:
		srcPath = '../../../../../../../../Media/' + mediaFolder
		dstPath = dstAssetsPath + mediaFolder
		print( 'Generating symlink from ' + srcPath + ' to ' + dstPath )
		os.remove( dstPath )
		os.symlink( srcPath, dstPath )

	# Copy template
	for templateFile in templateFiles:
		newPath = templateFile.replace( templateFile[:len("./Template")], './Autogen/' + sampleName )
		os.makedirs( os.path.dirname( newPath ), exist_ok=True )
		bFound = False
		for genFile in genFiles:
			if newPath.find( genFile ) >= 0:
				bFound = True
				break
		if not bFound:
			# Raw copy
			print( 'Copying ' + templateFile + ' into ' + newPath )
			shutil.copyfile( templateFile, newPath )
		else:
			# We must replace some strings to customize the template for each project
			print( 'Generating ' + templateFile + ' into ' + newPath )
			fileData = open( templateFile, 'r' ).read()
			fileData = fileData.replace( '%%sampleName%%', sampleName )
			fileData = fileData.replace( '%%prefixSampleName%%', 'Sample_' + sampleName )
			fileData = fileData.replace( '%%ogreBinaries%%', ogreBinariesPath )
			fileData = fileData.replace( '%%ogreSource%%', ogreSourcePath )
			dstFile = open( newPath, 'w' )
			dstFile.write( fileData )