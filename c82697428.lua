--V・HEROウィッチ・レイド
function c82697428.initial_effect(c)
	--summon with s/t
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82697428,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c82697428.otcon)
	e1:SetOperation(c82697428.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82697428,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCost(c82697428.descost)
	e2:SetTarget(c82697428.destg)
	e2:SetOperation(c82697428.desop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(82697428,ACTIVITY_SPSUMMON,c82697428.counterfilter)
end
function c82697428.counterfilter(c)
	return c:IsSetCard(0x8)
end
function c82697428.otfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsReleasable()
end
function c82697428.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c82697428.otfilter,tp,LOCATION_SZONE,0,nil)
	return c:GetLevel()>6 and minc<=2
		and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=2
			or Duel.CheckTribute(c,1) and mg:GetCount()>=1)
		or c:GetLevel()>4 and c:GetLevel()<=6 and minc<=1
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=1
end
function c82697428.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c82697428.otfilter,tp,LOCATION_SZONE,0,nil)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=2
	local b2=Duel.CheckTribute(c,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=mg:Select(tp,1,1,nil)
	if c:GetLevel()>6 then
		local g2=nil
		if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(82697428,2))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			g2=mg:Select(tp,1,1,g:GetFirst())
		else
			g2=Duel.SelectTribute(tp,c,1,1)
		end
		g:Merge(g2)
	end
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c82697428.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(82697428,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c82697428.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c82697428.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x8)
end
function c82697428.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c82697428.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82697428.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c82697428.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c82697428.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c82697428.desfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
