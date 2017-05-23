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
function c22198672.filter(c,tp)
	if c:IsFacedown() or not c:IsType(TYPE_LINK) then return false end
	local zone=c:GetLinkedZone()
	if c:GetSequence()>4 then zone=bit.band(zone,0xfff) end
	if c:IsControler(1-tp) then zone=bit.lshift(zone,0x10) end
	return zone~=0
end
function c22198672.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22198672.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c22198672.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22198672,2))
	Duel.SelectTarget(tp,c22198672.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
end
function c22198672.seqop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local zone=tc:GetLinkedZone()
	if tc:GetSequence()>4 then zone=bit.band(zone,0xfff) end
	if tc:IsControler(1-tp) then zone=bit.lshift(zone,0x10) end
	if zone~=0 then
		local flag=0
		local s=0
		if tc:IsControler(tp) then
			flag=bit.bxor(zone,0xff)
			Duel.Hint(HINT_SELECTMSG,tp,571)
			s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
		else
			flag=bit.bxor(zone,0xff0000)
			Duel.Hint(HINT_SELECTMSG,tp,571)
			s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,flag)
		end
		local nseq=0
		if s==1 or s==0x10000 then nseq=0
		elseif s==2 or s==0x20000 then nseq=1
		elseif s==4 or s==0x40000 then nseq=2
		elseif s==8 or s==0x80000 then nseq=3
		else nseq=4 end
		Duel.MoveSequence(tc,nseq)
	end
end
function c22198672.chfilter1(c,tp)
	return c:GetSequence()<5 and Duel.IsExistingMatchingCard(c22198672.chfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetControler())
end
function c22198672.chfilter2(c,tp)
	return c:GetSequence()<5 and c:IsControler(tp)
end
function c22198672.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22198672.chfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
end
function c22198672.chop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e)
		or not Duel.IsExistingMatchingCard(c22198672.chfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectMatchingCard(tp,c22198672.chfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.HintSelection(g1)
	local tc1=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g2=Duel.SelectMatchingCard(tp,c22198672.chfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc1,tc1:GetControler())
	Duel.HintSelection(g2)
	local tc2=g2:GetFirst()
	Duel.SwapSequence(tc1,tc2)
end
