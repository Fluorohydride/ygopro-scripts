--木花咲弥
---@param c Card
function c57722593.initial_effect(c)
	c:EnableReviveLimit()
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SPSUMMON_SUCCESS)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,57722593+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c57722593.sprcon)
	c:RegisterEffect(e1)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(57722593,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c57722593.acttg)
	e3:SetOperation(c57722593.actop)
	c:RegisterEffect(e3)
end
function c57722593.sprfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPIRIT)
end
function c57722593.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c57722593.sprfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c57722593.cfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsFaceup()
end
function c57722593.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c57722593.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c57722593.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c57722593.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c57722593.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
	end
end
