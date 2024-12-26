--革命の御旗
---@param c Card
function c73193552.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(73193552,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+73193552)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,73193552)
	e2:SetCondition(c73193552.condition)
	e2:SetTarget(c73193552.target)
	e2:SetOperation(c73193552.operation)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(73193552,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,73193553)
	e3:SetTarget(c73193552.atktg)
	e3:SetOperation(c73193552.atkop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,73193554)
	e4:SetTarget(c73193552.desreptg)
	e4:SetOperation(c73193552.desrepop)
	c:RegisterEffect(e4)
	if not c73193552.global_check then
		c73193552.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetCondition(c73193552.regcon)
		ge1:SetOperation(c73193552.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c73193552.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c73193552.regcon(e,tp,eg,ep,ev,re,r,rp)
	local v=0
	if eg:IsExists(c73193552.cfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(c73193552.cfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function c73193552.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+73193552,re,r,rp,ep,e:GetLabel())
end
function c73193552.condition(e,tp,eg,ep,ev,re,r,rp)
	return ev==tp or ev==PLAYER_ALL
end
function c73193552.thfilter(c)
	return c:IsCode(72022087) and c:IsAbleToHand()
end
function c73193552.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c73193552.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c73193552.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c73193552.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c73193552.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a,d=Duel.GetBattleMonster(tp)
	if chk==0 then return a and d and (a:IsFaceup() and a:IsType(TYPE_SYNCHRO) or d:IsFaceup() and d:IsType(TYPE_SYNCHRO)) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,1,0,0)
end
function c73193552.atkop(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetBattleMonster(tp)
	if d and d:IsRelateToBattle() then
		Duel.Destroy(d,REASON_EFFECT)
	end
end
function c73193552.repfilter(c,e)
	return c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c73193552.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT) and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c73193552.repfilter,tp,LOCATION_MZONE,0,1,nil,e) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c73193552.repfilter,tp,LOCATION_MZONE,0,1,1,nil,e)
		e:SetLabelObject(g:GetFirst())
		Duel.HintSelection(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c73193552.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
