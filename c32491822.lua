--降雷皇ハモン
function c32491822.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c32491822.spcon)
	e2:SetTarget(c32491822.sptg)
	e2:SetOperation(c32491822.spop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(32491822,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCondition(c32491822.damcon)
	e3:SetTarget(c32491822.damtg)
	e3:SetOperation(c32491822.damop)
	c:RegisterEffect(e3)
	--atk limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetCondition(c32491822.atcon)
	e4:SetValue(c32491822.atlimit)
	c:RegisterEffect(e4)
end
function c32491822.spfilter(c,check)
	return c:IsAbleToGraveAsCost()
		and (c:IsFaceup() and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS or check and c:IsFacedown() and c:IsType(TYPE_SPELL))
end
function c32491822.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local check=Duel.IsPlayerAffectedByEffect(tp,54828837)
	local g=Duel.GetMatchingGroup(c32491822.spfilter,tp,LOCATION_ONFIELD,0,nil,check)
	return g:CheckSubGroup(aux.mzctcheck,3,3,tp)
end
function c32491822.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local check=Duel.IsPlayerAffectedByEffect(tp,54828837)
	local g=Duel.GetMatchingGroup(c32491822.spfilter,tp,LOCATION_ONFIELD,0,nil,check)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,aux.mzctcheck,true,3,3,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c32491822.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c32491822.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE) and bc:IsType(TYPE_MONSTER)
end
function c32491822.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c32491822.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c32491822.atcon(e)
	return e:GetHandler():IsDefensePos()
end
function c32491822.atlimit(e,c)
	return c~=e:GetHandler()
end
