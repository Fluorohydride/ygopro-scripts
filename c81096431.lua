--ドレイク・シャーク
local s,id,o=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--flag
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	c:RegisterEffect(e2)
	--material effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.xyzcon)
	e3:SetCost(s.xyzcost)
	e3:SetTarget(s.xyztg)
	e3:SetOperation(s.xyzop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		Drake_shark_AddXyzProcedure=aux.AddXyzProcedure
		function aux.AddXyzProcedure(card_c,function_f,int_lv,int_ct,function_alterf,int_dese,int_maxc,function_op)
			if card_c:IsAttribute(ATTRIBUTE_WATER) and int_ct>=3 then
				if function_alterf then
					Drake_shark_XyzLevelFreeOperationAlter=Auxiliary.XyzLevelFreeOperationAlter
					function Auxiliary.XyzLevelFreeOperationAlter(f,gf,minc,maxc,alterf,alterdesc,alterop)
						return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
									if og and not min then
										if og:GetCount()==minc and og:IsExists(s.xfilter,1,nil) then
											local ttc=og:Filter(s.xfilter,nil):GetFirst()
											local tte=ttc:IsHasEffect(id,tp)
											tte:UseCountLimit(tp)
										end
										local sg=Group.CreateGroup()
										local tc=og:GetFirst()
										while tc do
											local sg1=tc:GetOverlayGroup()
											sg:Merge(sg1)
											tc=og:GetNext()
										end
										Duel.SendtoGrave(sg,REASON_RULE)
										c:SetMaterial(og)
										Duel.Overlay(c,og)
									else
										local mg=e:GetLabelObject()
										if mg:GetCount()==minc and mg:IsExists(s.xfilter,1,nil) then
											local ttc=mg:Filter(s.xfilter,nil):GetFirst()
											local tte=ttc:IsHasEffect(id,tp)
											tte:UseCountLimit(tp)
										end
										if e:GetLabel()==1 then
											local mg2=mg:GetFirst():GetOverlayGroup()
											if mg2:GetCount()~=0 then
												Duel.Overlay(c,mg2)
											end
										else
											local sg=Group.CreateGroup()
											local tc=mg:GetFirst()
											while tc do
												local sg1=tc:GetOverlayGroup()
												sg:Merge(sg1)
												tc=mg:GetNext()
											end
											Duel.SendtoGrave(sg,REASON_RULE)
										end
										c:SetMaterial(mg)
										Duel.Overlay(c,mg)
										mg:DeleteGroup()
									end
								end
					end
					aux.AddXyzProcedureLevelFree(card_c,s.f(function_f,int_lv,card_c),s.gf(int_ct,card_c:GetOwner()),int_ct-1,int_ct,function_alterf,int_dese,function_op)
					Auxiliary.XyzLevelFreeOperationAlter=Drake_shark_XyzLevelFreeOperationAlter
				else
					Drake_shark_XyzLevelFreeOperation=Auxiliary.XyzLevelFreeOperation
					function Auxiliary.XyzLevelFreeOperation(f,gf,minct,maxct)
						return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
									if og and not min then
										if og:GetCount()==minct and og:IsExists(s.xfilter,1,nil) then
											local ttc=og:Filter(s.xfilter,nil):GetFirst()
											local tte=ttc:IsHasEffect(id,tp)
											tte:UseCountLimit(tp)
										end
										local sg=Group.CreateGroup()
										local tc=og:GetFirst()
										while tc do
											local sg1=tc:GetOverlayGroup()
											sg:Merge(sg1)
											tc=og:GetNext()
										end
										Duel.SendtoGrave(sg,REASON_RULE)
										c:SetMaterial(og)
										Duel.Overlay(c,og)
									else
										local mg=e:GetLabelObject()
										if mg:GetCount()==minct and mg:IsExists(s.xfilter,1,nil) then
											local ttc=mg:Filter(s.xfilter,nil):GetFirst()
											local tte=ttc:IsHasEffect(id,tp)
											tte:UseCountLimit(tp)
										end
										if e:GetLabel()==1 then
											local mg2=mg:GetFirst():GetOverlayGroup()
											if mg2:GetCount()~=0 then
												Duel.Overlay(c,mg2)
											end
										else
											local sg=Group.CreateGroup()
											local tc=mg:GetFirst()
											while tc do
												local sg1=tc:GetOverlayGroup()
												sg:Merge(sg1)
												tc=mg:GetNext()
											end
											Duel.SendtoGrave(sg,REASON_RULE)
										end
										c:SetMaterial(mg)
										Duel.Overlay(c,mg)
										mg:DeleteGroup()
									end
								end
					end
					aux.AddXyzProcedureLevelFree(card_c,s.f(function_f,int_lv,card_c),s.gf(int_ct,card_c:GetOwner()),int_ct-1,int_ct)
					Auxiliary.XyzLevelFreeOperation=Drake_shark_XyzLevelFreeOperation
				end
			else
				if function_alterf then
					Drake_shark_AddXyzProcedure(card_c,function_f,int_lv,int_ct,function_alterf,int_dese,int_maxc,function_op)
				else
					Drake_shark_AddXyzProcedure(card_c,function_f,int_lv,int_ct,nil,nil,int_maxc,nil)
				end
			end
		end
	end
end
function s.f(function_f,int_lv,card_c)
	return function (c)
			   return c:IsXyzLevel(card_c,int_lv) and (not function_f or function_f(c))
	end
end
function s.gf(int_ct,int_tp)
	return function (g)
			   return g:GetCount()==int_ct or g:GetCount()==int_ct-1 and g:IsExists(s.xfilter,1,nil,int_tp)
	end
end
function s.xfilter(c,tp)
	return c:IsHasEffect(id,tp)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
function s.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSetCard(0x11b8) and c:IsType(TYPE_XYZ)
end
function s.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsCanOverlay()
end
function s.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and s.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		tc:CancelToGrave()
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
