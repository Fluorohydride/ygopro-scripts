--エーリアン・ベーダー
function c76573247.initial_effect(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76573247,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c76573247.seqcon)
	e1:SetOperation(c76573247.seqop)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(c76573247.dircon)
	c:RegisterEffect(e2)
end
function c76573247.seqcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function c76573247.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
	local seq=c:GetSequence()
	if seq>4 then return end
	local flag=0
	if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag|(1<<(seq-1)) end
	if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag|(1<<(seq+1)) end
	if flag==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,~flag)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
end
function c76573247.dircon(e)
	return e:GetHandler():GetColumnGroup():FilterCount(Card.IsControler,nil,1-e:GetHandlerPlayer())==0
end
