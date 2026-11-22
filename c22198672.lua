--キャッスル・リンク
function c22198672.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22198672,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c22198672.seqtg)
	e2:SetOperation(c22198672.seqop)
	c:RegisterEffect(e2)
	--change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22198672,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c22198672.chtg)
	e3:SetOperation(c22198672.chop)
	c:RegisterEffect(e3)
end
function c22198672.filter(c)
	if not c:IsType(TYPE_LINK) then return false end
	local p=c:GetControler()
	local zone=c:GetLinkedZone()&0x1f
	return Duel.GetLocationCount(p,LOCATION_MZONE,PLAYER_NONE,0,zone)>0
end
function c22198672.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22198672.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22198672.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22198672,2))
	Duel.SelectTarget(tp,c22198672.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c22198672.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local p=tc:GetControler()
	local zone=tc:GetLinkedZone(p)&0x1f
	if Duel.GetLocationCount(p,LOCATION_MZONE,PLAYER_NONE,0,zone)>0 then
		local i=0
		if p~=tp then i=16 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,~(zone<<i))
		local nseq=math.log(s,2)-i
		Duel.MoveSequence(tc,nseq)
	end
end
function c22198672.chfilter(c)
	return c:IsType(TYPE_LINK) and c:GetSequence()<5
end
function c22198672.gcheck(g)
	if g:GetClassCount(Card.GetControler)~=1 then return false end
	return aux.swapzonecheck(g:GetFirst(),g:GetNext())
end
function c22198672.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c22198672.chfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:CheckSubGroup(c22198672.gcheck,2,2) end
end
function c22198672.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22198672.chfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:SelectSubGroup(tp,c22198672.gcheck,false,2,2)
	if not sg or sg:GetCount()~=2 then return end
	local tc1=sg:GetFirst()
	local tc2=sg:GetNext()
	Duel.HintSelection(sg)
	Duel.SwapSequence(tc1,tc2)
end
