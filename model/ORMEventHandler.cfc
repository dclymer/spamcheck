component output="false" extends="coldbox.system.orm.hibernate.EventHandler"{


	public void function postNew(any entity ) {
		super.postNew(arguments.entity);
	}


	public void function preLoad(any entity ) {
		super.preLoad(arguments.entity);
	}

	public void function preUpdate( any entity, Struct oldData ) {
		if(structKeyExists(arguments.entity, "setupdated")){
			arguments.entity.setupdated( now() );
		}
	}

	public void function preInsert(any entity ) {
		if(structKeyExists(arguments.entity, 'setcreated') && structKeyExists(arguments.entity,'getcreated')){
			if(
				IsNull( arguments.entity.getCreated() ) ||
				!IsDate( arguments.entity.getCreated() )
			) {
				arguments.entity.setCreated( now() );
			}
		}
		if(structKeyExists(arguments.entity, 'setupdated') && structKeyExists(arguments.entity,'getupdated')){
			if(
				IsNull( arguments.entity.getUpdated() ) ||
				!IsDate( arguments.entity.getUpdated() )
			) {
				arguments.entity.setUpdated( now() );
			}
		}
		super.preInsert(arguments.entity);
	}

	public void function preDelete(any entity ) {
		super.preDelete(arguments.entity);
	}



	public void function postLoad(any entity ) {
		super.postLoad(arguments.entity);
	}

	public void function postInsert(any entity ) {
		super.postInsert(arguments.entity);
	}

	public void function postUpdate(any entity ) {
		super.postUpdate(arguments.entity);
	}

	public void function postDelete(any entity ) {
		super.postDelete(arguments.entity);
	}


}