--万物創世龍
function c10000.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c10000.spcon)
	e2:SetTarget(c10000.sptg)
	e2:SetOperation(c10000.spop)
	c:RegisterEffect(e2)
end
function c10000.rfilter(c,tp)
	return c:IsControler(tp) or c:IsFaceup()
end
function c10000.sumfilter(c)
	return c:GetAttack()+c:GetDefense()
end
function c10000.fselect(g,tp)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(c10000.sumfilter,10000) and aux.mzctcheckrel(g,tp)
end
function c10000.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(c10000.rfilter,nil,tp)
	return rg:CheckSubGroup(c10000.fselect,1,rg:GetCount(),tp)
end
function c10000.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(c10000.rfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,c10000.fselect,true,1,rg:GetCount(),tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c10000.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(10000)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e2)
	g:DeleteGroup()
end
