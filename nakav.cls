Class User.nakav Extends %Persistent
{

Property feedback As %String(MAXLEN = 3000);

Property feedbackv As %Vector(DATATYPE = "DOUBLE", LEN = 384);

ClassMethod Embedd(sentences) As %String [ Language = python ]
{
	from sentence_transformers import SentenceTransformer

	model = SentenceTransformer('sentence-transformers/all-MiniLM-L6-v2')
	embeddings = model.encode(sentences, normalize_embeddings = True)

	# convert the embeddings to a string
	embeddings_list = [str(embedding.tolist()) for embedding in embeddings]
	s1 = str(embeddings_list)

	# remove apostrophes
	return s1.replace('\'','')
}

ClassMethod insert(feedback As %String)
{
	set v=..Embedd(feedback)
	&sql(insert into nakav (feedback, feedbackv) values (:feedback, TO_VECTOR(:v, DOUBLE, 384) ) )
}

ClassMethod init()
{
	do ..%KillExtent()
	do ..insert("Your sample code helped us a lot.")
	do ..insert("I expected a quicker response.")
	do ..insert("I was glad to receive good advice.")
	do ..insert("I wanted more detailed information.")
	do ..insert("Your support was awesome!")
}

ClassMethod search()
{
	set v=..Embedd("better feedback")
	set sql="SELECT ID, feedback FROM nakav ORDER BY VECTOR_DOT_PRODUCT(feedbackv, TO_VECTOR(?, DOUBLE, 384)) "
	set rs=##class(%SQL.Statement).%ExecDirect(.stmt,sql,v)
	while rs.%Next() {
		write rs.%Get("ID")," : ",rs.%Get("feedback"),!
	}
}

}
