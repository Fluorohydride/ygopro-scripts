--護石の作庭
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Trap activate in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.actcon)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_CONTINUOUS))
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--reduce battle damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,1)
	e3:SetValue(HALF_DAMAGE)
	e3:SetCondition(s.actcon)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SSET)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.settg)
	e4:SetOperation(s.setop)
	c:RegisterEffect(e4)
end
function s.cfilter(c)
	return c:GetSequence()<5
end
function s.actcon(e)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,5,nil)
end
function s.setfilter(c)
	return c:GetType()==TYPE_TRAP+TYPE_CONTINUOUS and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and g:GetClassCount(Card.GetCode)>=5 end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:GetClassCount(Card.GetCode)>=5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,5,5)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
		local tg=sg:RandomSelect(1-tp,1)
		Duel.ShuffleDeck(tp)
		Duel.SSet(tp,tg,tp,false)
	end
end
