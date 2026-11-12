--S－Force ミスティファイ
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,s.lcheck)
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.indcon)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCondition(s.indcon)
	e2:SetTarget(s.sumlimit)
	c:RegisterEffect(e2)
	--zone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.zonetg)
	e3:SetOperation(s.zoneop)
	c:RegisterEffect(e3)
end
function s.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x156)
end
function s.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsControler(1-tp) and c:IsOnField()
end
function s.indcon(e)
	local cg=e:GetHandler():GetColumnGroup()
	return cg:IsExists(s.cfilter,1,nil,e:GetHandlerPlayer())
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se:IsActiveType(TYPE_MONSTER) and se:IsActivated()
		and c:IsType(TYPE_MONSTER)
end
function s.filter(c)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,PLAYER_NONE,0)>0
end
function s.zonetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function s.zoneop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToChain() or Duel.GetLocationCount(tc:GetControler(),LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	if tc:IsControler(tp) then
		local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		Duel.Hint(HINT_ZONE,tp,fd)
		local seq=math.log(fd,2)
		Duel.MoveSequence(tc,seq)
	else
		local fd=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
		Duel.Hint(HINT_ZONE,tp,fd)
		local nseq=math.log(bit.rshift(fd,16),2)
		Duel.MoveSequence(tc,nseq)
	end
end
