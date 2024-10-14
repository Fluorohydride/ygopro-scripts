--剛鬼ザ・ソリッド・オーガ
---@param c Card
function c22510667.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xfc),2)
	c:EnableReviveLimit()
	--indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c22510667.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c22510667.seqtg)
	e3:SetOperation(c22510667.seqop)
	c:RegisterEffect(e3)
end
function c22510667.lkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfc)
end
function c22510667.indcon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(c22510667.lkfilter,1,nil)
end
function c22510667.seqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfc) and c:GetSequence()<5 and not c:IsCode(22510667)
end
function c22510667.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22510667.seqfilter(chkc) end
	if chk==0 then
		local zone=bit.band(e:GetHandler():GetLinkedZone(),0x1f)
		return Duel.IsExistingTarget(c22510667.seqfilter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0,zone)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22510667,0))
	Duel.SelectTarget(tp,c22510667.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c22510667.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local zone=bit.band(e:GetHandler():GetLinkedZone(),0x1f)
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp)
		or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0,zone)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local flag=bit.bxor(zone,0xff)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end
