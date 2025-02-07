--Mimighoul Dungeon
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--can not spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(s.effcon1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetTargetRange(0,1)
	e3:SetCondition(s.effcon2)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetValue(s.atkval)
	e5:SetTarget(s.atktg)
	c:RegisterEffect(e5)
	--cannot attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetTarget(s.atktarget)
	c:RegisterEffect(e6)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE+RESET_PHASE+PHASE_END,0,1)
		if tc:IsSummonType(SUMMON_TYPE_SPECIAL) then
			tc:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE+RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function s.atktg(e,c)
	return c:IsSetCard(0x1b7) and c:GetFlagEffect(id)==0
end
function s.atkval(e,c)
	return c:GetBaseDefense()
end
function s.atktarget(e,c)
	return c:GetFlagEffect(id+1)>0 and Duel.IsExistingMatchingCard(Card.IsFacedown,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function s.effcon1(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil)
end
function s.effcon2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_MZONE,1,nil)
end
function s.thfilter(c)
	return c:IsSetCard(0x1b7) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
	end
end
