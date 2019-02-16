--剣聖の影霊衣－セフィラセイバー
function c84388461.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c84388461.splimit)
	c:RegisterEffect(e2)
	--spsummon
	local e3=aux.AddRitualProcEqual2(c,c84388461.filter,nil,nil,c84388461.mfilter)
	e3:SetDescription(aux.Stringid(84388461,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(0)
	e3:SetCountLimit(1,84388461)
	e3:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e3:SetCost(c84388461.cost)
end
function c84388461.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xb4) or c:IsSetCard(0xc4) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c84388461.filter(c)
	return c:IsSetCard(0xb4)
end
function c84388461.mfilter(c,e,tp)
	return c~=e:GetHandler()
end
function c84388461.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
