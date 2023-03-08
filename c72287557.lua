--ヘル・ポリマー
function c72287557.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c72287557.condition)
	e1:SetCost(c72287557.cost)
	e1:SetTarget(c72287557.target)
	e1:SetOperation(c72287557.activate)
	c:RegisterEffect(e1)
end
function c72287557.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:GetCount()==1 and tc:IsControler(1-tp) and tc:IsSummonType(SUMMON_TYPE_FUSION)
end
function c72287557.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c72287557.costfilter(c,tp)
	return Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c72287557.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local tc=eg:GetFirst()
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.CheckReleaseGroup(tp,c72287557.costfilter,1,tc,tp)
				and tc:IsCanBeEffectTarget(e) and tc:IsControlerCanBeChanged(true)
		else
			return tc:IsCanBeEffectTarget(e) and tc:IsControlerCanBeChanged()
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local sg=Duel.SelectReleaseGroup(tp,c72287557.costfilter,1,1,tc,tp)
		Duel.Release(sg,REASON_COST)
	end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg,1,0,0)
end
function c72287557.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end
